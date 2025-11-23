import { createClient } from "@/lib/supabase/server"
import { type NextRequest, NextResponse } from "next/server"

function convertWorkOrderData(data: any) {
  return {
    WorkOrderID: data.work_order_id,
    WorkOrderNumber: data.work_order_number,
    RequestID: data.request_id,
    UnitID: data.unit_id,
    CreatedByManagerID: data.created_by_manager_id,
    VendorID: data.vendor_id,
    WorkType: data.work_type,
    WorkDescription: data.work_description,
    ScheduledDate: data.scheduled_date,
    StartDateTime: data.start_date_time,
    CompletionDateTime: data.completion_date_time,
    WorkStatus: data.work_status,
    EstimatedCost: data.estimated_cost,
    ActualCost: data.actual_cost,
    RequiresApproval: data.requires_approval,
    ApprovedByManagerID: data.approved_by_manager_id,
    ApprovalDate: data.approval_date,
  }
}

export async function GET(req: NextRequest) {
  try {
    console.log("[v0] GET /api/work-orders - Fetching work orders")
    const supabase = await createClient()
    const { data, error } = await supabase.from("work_order").select("*").order("work_order_id", { ascending: true })

    if (error) throw error
    const convertedData = data?.map(convertWorkOrderData) || []
    return NextResponse.json(convertedData)
  } catch (error) {
    console.error("[v0] Error:", error)
    return NextResponse.json({ error: "Failed to fetch work orders" }, { status: 500 })
  }
}

export async function POST(req: NextRequest) {
  try {
    const body = await req.json()
    const {
      WorkOrderNumber,
      RequestID,
      UnitID,
      CreatedByManagerID,
      VendorID,
      WorkType,
      WorkDescription,
      ScheduledDate,
      WorkStatus,
      EstimatedCost,
      ActualCost,
      RequiresApproval,
      ApprovedByManagerID,
      ApprovalDate,
    } = body

    const supabase = await createClient()

    const { data: maxData } = await supabase
      .from("work_order")
      .select("work_order_id")
      .order("work_order_id", { ascending: false })
      .limit(1)

    const nextId = maxData && maxData.length > 0 ? maxData[0].work_order_id + 1 : 1

    const { data, error } = await supabase
      .from("work_order")
      .insert([
        {
          work_order_id: nextId, // Using auto-generated ID
          work_order_number: WorkOrderNumber,
          request_id: RequestID || null,
          unit_id: UnitID,
          created_by_manager_id: CreatedByManagerID,
          vendor_id: VendorID || null,
          work_type: WorkType,
          work_description: WorkDescription,
          scheduled_date: ScheduledDate || null,
          start_date_time: null,
          completion_date_time: null,
          work_status: WorkStatus || "Pending",
          estimated_cost: EstimatedCost || null,
          actual_cost: ActualCost || null,
          requires_approval: RequiresApproval || false,
          approved_by_manager_id: ApprovedByManagerID || null,
          approval_date: ApprovalDate || null,
        },
      ])
      .select()

    if (error) throw error
    const convertedData = data?.[0] ? convertWorkOrderData(data[0]) : null
    return NextResponse.json({ message: "Work order created successfully", data: convertedData }, { status: 201 })
  } catch (error) {
    console.error("[v0] Error:", error)
    return NextResponse.json({ error: "Failed to create work order" }, { status: 500 })
  }
}

export async function PUT(req: NextRequest) {
  try {
    const body = await req.json()
    const { WorkOrderID, ...updateData } = body

    const updates: Record<string, any> = {}
    if (updateData.WorkStatus) updates.work_status = updateData.WorkStatus
    if (updateData.ScheduledDate) updates.scheduled_date = updateData.ScheduledDate
    if (updateData.StartDateTime) updates.start_date_time = updateData.StartDateTime
    if (updateData.CompletionDateTime) updates.completion_date_time = updateData.CompletionDateTime
    if (updateData.EstimatedCost) updates.estimated_cost = updateData.EstimatedCost
    if (updateData.ActualCost) updates.actual_cost = updateData.ActualCost
    if (updateData.RequiresApproval) updates.requires_approval = updateData.RequiresApproval
    if (updateData.ApprovedByManagerID) updates.approved_by_manager_id = updateData.ApprovedByManagerID
    if (updateData.ApprovalDate) updates.approval_date = updateData.ApprovalDate

    const supabase = await createClient()
    const { data, error } = await supabase.from("work_order").update(updates).eq("work_order_id", WorkOrderID).select()

    if (error) throw error
    const convertedData = data?.[0] ? convertWorkOrderData(data[0]) : null
    return NextResponse.json({ message: "Work order updated successfully", data: convertedData })
  } catch (error) {
    console.error("[v0] Error:", error)
    return NextResponse.json({ error: "Failed to update work order" }, { status: 500 })
  }
}

export async function DELETE(req: NextRequest) {
  try {
    const { searchParams } = new URL(req.url)
    const workOrderId = searchParams.get("id")

    if (!workOrderId) {
      return NextResponse.json({ error: "Work Order ID is required" }, { status: 400 })
    }

    const supabase = await createClient()
    const id = Number.parseInt(workOrderId)

    // Delete worker assignments
    await supabase.from("worker_assignment").delete().eq("work_order_id", id)

    // Delete invoices
    await supabase.from("invoice").delete().eq("work_order_id", id)

    // Now delete the work order
    const { error } = await supabase.from("work_order").delete().eq("work_order_id", id)

    if (error) {
      console.error("[v0] Error:", error)
      return NextResponse.json({ error: error.message }, { status: 500 })
    }

    return NextResponse.json({ message: "Work order deleted successfully" })
  } catch (error) {
    console.error("[v0] Error:", error)
    return NextResponse.json({ error: "Failed to delete work order" }, { status: 500 })
  }
}
