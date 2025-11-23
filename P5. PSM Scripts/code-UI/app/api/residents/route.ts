import { createClient } from "@/lib/supabase/server"
import { type NextRequest, NextResponse } from "next/server"

function convertResidentData(data: any) {
  return {
    ResidentID: data.resident_id,
    FirstName: data.first_name,
    LastName: data.last_name,
    DateOfBirth: data.date_of_birth,
    SSNLast4: data.ssn_last4,
    PrimaryPhone: data.primary_phone,
    AlternatePhone: data.alternate_phone,
    EmailAddress: data.email_address,
    CurrentAddress: data.current_address,
    AccountStatus: data.account_status,
    BackgroundCheckStatus: data.background_check_status,
    BackgroundCheckDate: data.background_check_date,
    CreditScore: data.credit_score,
    CreatedDate: data.created_date,
    ModifiedDate: data.modified_date,
  }
}

export async function GET(req: NextRequest) {
  try {
    console.log("[v0] GET /api/residents - Fetching residents")
    const supabase = await createClient()
    const { data, error } = await supabase.from("resident").select("*").order("resident_id", { ascending: true })

    if (error) {
      console.error("[v0] Supabase error:", error)
      return NextResponse.json({ error: error.message }, { status: 500 })
    }

    const convertedData = data?.map(convertResidentData) || []
    console.log("[v0] Successfully fetched", convertedData.length, "residents")
    return NextResponse.json(convertedData)
  } catch (error) {
    console.error("[v0] Error fetching residents:", error)
    return NextResponse.json({ error: "Failed to fetch residents" }, { status: 500 })
  }
}

export async function POST(req: NextRequest) {
  try {
    const body = await req.json()
    const {
      FirstName,
      LastName,
      DateOfBirth,
      SSNLast4,
      PrimaryPhone,
      AlternatePhone,
      EmailAddress,
      CurrentAddress,
      AccountStatus,
      BackgroundCheckStatus,
      BackgroundCheckDate,
      CreditScore,
    } = body

    console.log("[v0] POST /api/residents - Creating new resident:", { FirstName, LastName, EmailAddress })

    const supabase = await createClient()

    const { data: maxData } = await supabase
      .from("resident")
      .select("resident_id")
      .order("resident_id", { ascending: false })
      .limit(1)

    const nextId = maxData && maxData.length > 0 ? maxData[0].resident_id + 1 : 1

    const { data, error } = await supabase
      .from("resident")
      .insert({
        resident_id: nextId,
        first_name: FirstName,
        last_name: LastName,
        date_of_birth: DateOfBirth,
        ssn_last4: SSNLast4,
        primary_phone: PrimaryPhone,
        alternate_phone: AlternatePhone,
        email_address: EmailAddress,
        current_address: CurrentAddress,
        account_status: AccountStatus || "Active",
        background_check_status: BackgroundCheckStatus,
        background_check_date: BackgroundCheckDate,
        credit_score: CreditScore,
      })
      .select()

    if (error) {
      console.error("[v0] Supabase error:", error)
      return NextResponse.json({ error: error.message }, { status: 500 })
    }

    console.log("[v0] Resident created successfully with ID:", nextId)
    const convertedData = data?.[0] ? convertResidentData(data[0]) : null
    return NextResponse.json({ message: "Resident created successfully", data: convertedData }, { status: 201 })
  } catch (error) {
    console.error("[v0] Error creating resident:", error)
    return NextResponse.json({ error: "Failed to create resident" }, { status: 500 })
  }
}

export async function PUT(req: NextRequest) {
  try {
    const body = await req.json()
    const { ResidentID, ...updateData } = body

    const updates: Record<string, any> = {}
    if (updateData.FirstName) updates.first_name = updateData.FirstName
    if (updateData.LastName) updates.last_name = updateData.LastName
    if (updateData.DateOfBirth) updates.date_of_birth = updateData.DateOfBirth
    if (updateData.SSNLast4) updates.ssn_last4 = updateData.SSNLast4
    if (updateData.EmailAddress) updates.email_address = updateData.EmailAddress
    if (updateData.PrimaryPhone) updates.primary_phone = updateData.PrimaryPhone
    if (updateData.AlternatePhone !== undefined) updates.alternate_phone = updateData.AlternatePhone
    if (updateData.CurrentAddress !== undefined) updates.current_address = updateData.CurrentAddress
    if (updateData.AccountStatus) updates.account_status = updateData.AccountStatus
    if (updateData.BackgroundCheckStatus !== undefined) updates.background_check_status = updateData.BackgroundCheckStatus
    if (updateData.BackgroundCheckDate !== undefined) updates.background_check_date = updateData.BackgroundCheckDate
    if (updateData.CreditScore !== undefined) updates.credit_score = updateData.CreditScore
    updates.modified_date = new Date().toISOString()

    const supabase = await createClient()
    const { data, error } = await supabase.from("resident").update(updates).eq("resident_id", ResidentID).select()

    if (error) {
      console.error("[v0] Supabase error:", error)
      return NextResponse.json({ error: error.message }, { status: 500 })
    }

    const convertedData = data?.[0] ? convertResidentData(data[0]) : null
    return NextResponse.json({ message: "Resident updated successfully", data: convertedData })
  } catch (error) {
    console.error("[v0] Error updating resident:", error)
    return NextResponse.json({ error: "Failed to update resident" }, { status: 500 })
  }
}

export async function DELETE(req: NextRequest) {
  try {
    const { searchParams } = new URL(req.url)
    const residentId = searchParams.get("id")

    if (!residentId) {
      return NextResponse.json({ error: "Resident ID is required" }, { status: 400 })
    }

    const supabase = await createClient()
    const id = Number.parseInt(residentId)

    console.log("[v0] Starting cascade deletion for resident:", id)

    const { data: maintenanceRequests } = await supabase
      .from("maintenance_request")
      .select("request_id")
      .eq("resident_id", id)

    const requestIds = maintenanceRequests?.map((mr) => mr.request_id) || []
    console.log("[v0] Found maintenance requests:", requestIds)

    if (requestIds.length > 0) {
      const { data: workOrders } = await supabase
        .from("work_order")
        .select("work_order_id")
        .in("request_id", requestIds)

      const workOrderIds = workOrders?.map((wo) => wo.work_order_id) || []
      console.log("[v0] Found work orders:", workOrderIds)

      if (workOrderIds.length > 0) {
        console.log("[v0] Deleting invoices...")
        await supabase.from("invoice").delete().in("work_order_id", workOrderIds)

        console.log("[v0] Deleting worker assignments...")
        await supabase.from("worker_assignment").delete().in("work_order_id", workOrderIds)

        console.log("[v0] Deleting work orders...")
        await supabase.from("work_order").delete().in("request_id", requestIds)
      }

      console.log("[v0] Deleting escalations...")
      await supabase.from("escalation").delete().in("request_id", requestIds)

      console.log("[v0] Deleting notifications for maintenance requests...")
      await supabase.from("notification").delete().in("request_id", requestIds)
    }

    console.log("[v0] Deleting maintenance requests...")
    await supabase.from("maintenance_request").delete().eq("resident_id", id)

    console.log("[v0] Deleting emergency contacts...")
    await supabase.from("emergency_contact").delete().eq("resident_id", id)

    console.log("[v0] Deleting lease occupants...")
    await supabase.from("lease_occupant").delete().eq("resident_id", id)

    console.log("[v0] Deleting notifications...")
    await supabase.from("notification").delete().eq("resident_id", id)

    console.log("[v0] Deleting payment transactions...")
    await supabase.from("payment_transaction").delete().eq("resident_id", id)

    console.log("[v0] Deleting leases...")
    await supabase.from("lease").delete().eq("resident_id", id)

    console.log("[v0] Deleting resident...")
    const { error } = await supabase.from("resident").delete().eq("resident_id", id)

    if (error) {
      console.error("[v0] Supabase error:", error)
      return NextResponse.json({ error: error.message }, { status: 500 })
    }

    console.log("[v0] Resident deleted successfully")
    return NextResponse.json({ message: "Resident deleted successfully" })
  } catch (error) {
    console.error("[v0] Error deleting resident:", error)
    return NextResponse.json({ error: "Failed to delete resident" }, { status: 500 })
  }
}
