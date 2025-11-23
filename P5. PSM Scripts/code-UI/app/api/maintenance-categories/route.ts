import { type NextRequest, NextResponse } from "next/server"
import { createClient } from "@/lib/supabase/server"

export async function GET(req: NextRequest) {
  try {
    const supabase = await createClient()
    const { data, error } = await supabase.from("maintenance_category").select("*").order("category_id")

    if (error) throw error
    return NextResponse.json(data)
  } catch (error: any) {
    return NextResponse.json({ error: error.message }, { status: 500 })
  }
}

export async function POST(req: NextRequest) {
  try {
    const supabase = await createClient()
    const body = await req.json()

    const { data: maxData } = await supabase
      .from("maintenance_category")
      .select("category_id")
      .order("category_id", { ascending: false })
      .limit(1)
    
    const newId = maxData && maxData.length > 0 ? maxData[0].category_id + 1 : 1

    const { data, error } = await supabase
      .from("maintenance_category")
      .insert([{ ...body, category_id: newId, is_active: true }])
      .select()

    if (error) throw error
    return NextResponse.json(data[0], { status: 201 })
  } catch (error: any) {
    return NextResponse.json({ error: error.message }, { status: 500 })
  }
}

export async function PUT(req: NextRequest) {
  try {
    const supabase = await createClient()
    const body = await req.json()
    const { category_id, ...updates } = body

    const { data, error } = await supabase
      .from("maintenance_category")
      .update(updates)
      .eq("category_id", category_id)
      .select()

    if (error) throw error
    return NextResponse.json(data[0])
  } catch (error: any) {
    return NextResponse.json({ error: error.message }, { status: 500 })
  }
}

export async function DELETE(req: NextRequest) {
  try {
    const supabase = await createClient()
    const { searchParams } = new URL(req.url)
    const id = searchParams.get("id")

    // CASCADE: Delete maintenance_requests (and their dependencies) first
    const { data: requests } = await supabase.from("maintenance_request").select("request_id").eq("category_id", id)

    if (requests && requests.length > 0) {
      for (const req of requests) {
        // Delete work orders for each maintenance request
        const { data: workOrders } = await supabase
          .from("work_order")
          .select("work_order_id")
          .eq("request_id", req.request_id)

        if (workOrders) {
          for (const wo of workOrders) {
            await supabase.from("worker_assignment").delete().eq("work_order_id", wo.work_order_id)
            await supabase.from("invoice").delete().eq("work_order_id", wo.work_order_id)
          }
          await supabase.from("work_order").delete().eq("request_id", req.request_id)
        }

        await supabase.from("escalation").delete().eq("request_id", req.request_id)
        await supabase.from("notification").delete().eq("request_id", req.request_id)
      }

      await supabase.from("maintenance_request").delete().eq("category_id", id)
    }

    // Delete category
    const { error } = await supabase.from("maintenance_category").delete().eq("category_id", id)

    if (error) throw error
    return NextResponse.json({ success: true })
  } catch (error: any) {
    return NextResponse.json({ error: error.message }, { status: 500 })
  }
}
