import { createClient } from "@/lib/supabase/server"
import { type NextRequest, NextResponse } from "next/server"

function convertLeaseData(data: any) {
  return {
    LeaseID: data.lease_id,
    ResidentID: data.resident_id,
    UnitID: data.unit_id,
    PreparedByManagerID: data.prepared_by_manager_id,
    LeaseStartDate: data.lease_start_date,
    LeaseEndDate: data.lease_end_date,
    MonthlyRentAmount: data.monthly_rent_amount,
    SecurityDepositAmount: data.security_deposit_amount,
    PetDepositAmount: data.pet_deposit_amount,
    PaymentDueDay: data.payment_due_day,
    LateFeeAmount: data.late_fee_amount,
    GracePeriodDays: data.grace_period_days,
    LeaseStatus: data.lease_status,
  }
}

export async function GET(req: NextRequest) {
  try {
    console.log("[v0] GET /api/leases - Fetching leases")
    const supabase = await createClient()
    const { data, error } = await supabase.from("lease").select("*").order("lease_id", { ascending: true })

    if (error) throw error
    const convertedData = data?.map(convertLeaseData) || []
    return NextResponse.json(convertedData)
  } catch (error) {
    console.error("[v0] Error:", error)
    return NextResponse.json({ error: "Failed to fetch leases" }, { status: 500 })
  }
}

export async function POST(req: NextRequest) {
  try {
    const body = await req.json()
    const {
      ResidentID,
      UnitID,
      PreparedByManagerID,
      LeaseStartDate,
      LeaseEndDate,
      MonthlyRentAmount,
      SecurityDepositAmount,
      PetDepositAmount,
      PaymentDueDay,
      LateFeeAmount,
      GracePeriodDays,
      LeaseStatus,
    } = body

    const supabase = await createClient()
    
    const { data: maxData } = await supabase
      .from("lease")
      .select("lease_id")
      .order("lease_id", { ascending: false })
      .limit(1)
    
    const nextId = maxData && maxData.length > 0 ? maxData[0].lease_id + 1 : 1

    const { data, error } = await supabase
      .from("lease")
      .insert({
        lease_id: nextId, // Using auto-generated ID
        resident_id: ResidentID,
        unit_id: UnitID,
        prepared_by_manager_id: PreparedByManagerID,
        lease_start_date: LeaseStartDate,
        lease_end_date: LeaseEndDate,
        monthly_rent_amount: MonthlyRentAmount,
        security_deposit_amount: SecurityDepositAmount,
        pet_deposit_amount: PetDepositAmount || 0,
        payment_due_day: PaymentDueDay,
        late_fee_amount: LateFeeAmount || 0,
        grace_period_days: GracePeriodDays || 5,
        lease_status: LeaseStatus || "Draft",
      })
      .select()

    if (error) throw error
    const convertedData = data?.[0] ? convertLeaseData(data[0]) : null
    return NextResponse.json({ message: "Lease created successfully", data: convertedData }, { status: 201 })
  } catch (error) {
    console.error("[v0] Error:", error)
    return NextResponse.json({ error: "Failed to create lease" }, { status: 500 })
  }
}

export async function PUT(req: NextRequest) {
  try {
    const body = await req.json()
    const { LeaseID, ...updateData } = body

    const updates: Record<string, any> = {}
    if (updateData.LeaseStatus) updates.lease_status = updateData.LeaseStatus
    if (updateData.MonthlyRentAmount) updates.monthly_rent_amount = updateData.MonthlyRentAmount

    const supabase = await createClient()
    const { data, error } = await supabase.from("lease").update(updates).eq("lease_id", LeaseID).select()

    if (error) throw error
    const convertedData = data?.[0] ? convertLeaseData(data[0]) : null
    return NextResponse.json({ message: "Lease updated successfully", data: convertedData })
  } catch (error) {
    console.error("[v0] Error:", error)
    return NextResponse.json({ error: "Failed to update lease" }, { status: 500 })
  }
}

export async function DELETE(req: NextRequest) {
  try {
    const { searchParams } = new URL(req.url)
    const leaseId = searchParams.get("id")

    if (!leaseId) {
      return NextResponse.json({ error: "Lease ID is required" }, { status: 400 })
    }

    const supabase = await createClient()
    const id = Number.parseInt(leaseId)

    // Delete payment transactions
    await supabase.from("payment_transaction").delete().eq("lease_id", id)

    // Delete lease occupants
    await supabase.from("lease_occupant").delete().eq("lease_id", id)

    // Now delete the lease
    const { error } = await supabase.from("lease").delete().eq("lease_id", id)

    if (error) {
      console.error("[v0] Error:", error)
      return NextResponse.json({ error: error.message }, { status: 500 })
    }

    return NextResponse.json({ message: "Lease deleted successfully" })
  } catch (error) {
    console.error("[v0] Error:", error)
    return NextResponse.json({ error: "Failed to delete lease" }, { status: 500 })
  }
}
