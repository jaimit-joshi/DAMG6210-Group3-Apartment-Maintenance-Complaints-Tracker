import { createClient } from "@/lib/supabase/server"
import { type NextRequest, NextResponse } from "next/server"

function convertMaintenanceData(data: any) {
  return {
    RequestID: data.request_id,
    ResidentID: data.resident_id,
    UnitID: data.unit_id,
    CategoryID: data.category_id,
    RequestTitle: data.request_title,
    RequestDescription: data.request_description,
    RequestPriority: data.request_priority,
    RequestStatus: data.request_status,
    PermissionToEnter: data.permission_to_enter,
    PetOnPremises: data.pet_on_premises,
  }
}

export async function GET(req: NextRequest) {
  try {
    console.log("[v0] GET /api/maintenance - Fetching maintenance requests")
    const supabase = await createClient()
    const { data, error } = await supabase
      .from("maintenance_request")
      .select("*")
      .order("request_id", { ascending: true })

    if (error) throw error
    const convertedData = data?.map(convertMaintenanceData) || []
    return NextResponse.json(convertedData)
  } catch (error) {
    console.error("[v0] Error:", error)
    return NextResponse.json({ error: "Failed to fetch maintenance requests" }, { status: 500 })
  }
}

export async function POST(req: NextRequest) {
  try {
    const body = await req.json()
    const {
      ResidentID,
      UnitID,
      CategoryID,
      RequestTitle,
      RequestDescription,
      RequestPriority,
      RequestStatus,
      PermissionToEnter,
      PetOnPremises,
    } = body

    const supabase = await createClient()
    
    const { data: maxData } = await supabase
      .from("maintenance_request")
      .select("request_id")
      .order("request_id", { ascending: false })
      .limit(1)
    
    const nextId = maxData && maxData.length > 0 ? maxData[0].request_id + 1 : 1

    const { data, error } = await supabase
      .from("maintenance_request")
      .insert([
        {
          request_id: nextId, // Using auto-generated ID
          resident_id: ResidentID,
          unit_id: UnitID,
          category_id: CategoryID,
          request_title: RequestTitle,
          request_description: RequestDescription,
          request_priority: RequestPriority || "Normal",
          request_status: RequestStatus || "Submitted",
          permission_to_enter: PermissionToEnter || false,
          pet_on_premises: PetOnPremises || false,
        },
      ])
      .select()

    if (error) throw error
    const convertedData = data?.[0] ? convertMaintenanceData(data[0]) : null
    return NextResponse.json(
      { message: "Maintenance request created successfully", data: convertedData },
      { status: 201 },
    )
  } catch (error) {
    console.error("[v0] Error:", error)
    return NextResponse.json({ error: "Failed to create maintenance request" }, { status: 500 })
  }
}

export async function PUT(req: NextRequest) {
  try {
    const body = await req.json()
    const { RequestID, ...updateData } = body

    const updates: Record<string, any> = {}
    if (updateData.RequestStatus) updates.request_status = updateData.RequestStatus
    if (updateData.RequestPriority) updates.request_priority = updateData.RequestPriority

    const supabase = await createClient()
    const { data, error } = await supabase
      .from("maintenance_request")
      .update(updates)
      .eq("request_id", RequestID)
      .select()

    if (error) throw error
    const convertedData = data?.[0] ? convertMaintenanceData(data[0]) : null
    return NextResponse.json({ message: "Maintenance request updated successfully", data: convertedData })
  } catch (error) {
    console.error("[v0] Error:", error)
    return NextResponse.json({ error: "Failed to update maintenance request" }, { status: 500 })
  }
}

export async function DELETE(req: NextRequest) {
  try {
    const { searchParams } = new URL(req.url)
    const requestId = searchParams.get("id")

    if (!requestId) {
      return NextResponse.json({ error: "Request ID is required" }, { status: 400 })
    }

    const supabase = await createClient()
    const id = Number.parseInt(requestId)

    // Delete work orders
    await supabase.from("work_order").delete().eq("request_id", id)

    // Delete escalations
    await supabase.from("escalation").delete().eq("request_id", id)

    // Delete notifications
    await supabase.from("notification").delete().eq("request_id", id)

    // Now delete the maintenance request
    const { error } = await supabase.from("maintenance_request").delete().eq("request_id", id)

    if (error) {
      console.error("[v0] Error:", error)
      return NextResponse.json({ error: error.message }, { status: 500 })
    }

    return NextResponse.json({ message: "Maintenance request deleted successfully" })
  } catch (error) {
    console.error("[v0] Error:", error)
    return NextResponse.json({ error: "Failed to delete maintenance request" }, { status: 500 })
  }
}
