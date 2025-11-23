import { type NextRequest, NextResponse } from "next/server"
import { createClient } from "@/lib/supabase/server"

export async function GET(req: NextRequest) {
  try {
    const supabase = await createClient()
    const { data, error } = await supabase.from("worker").select("*").order("worker_id")

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
      .from("worker")
      .select("worker_id")
      .order("worker_id", { ascending: false })
      .limit(1)
    
    const newWorkerId = maxData && maxData.length > 0 ? maxData[0].worker_id + 1 : 1

    const { data, error } = await supabase
      .from("worker")
      .insert([{ ...body, worker_id: newWorkerId, worker_status: "Active" }])
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
    const { worker_id, ...updates } = body

    const { data, error } = await supabase.from("worker").update(updates).eq("worker_id", worker_id).select()

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

    // CASCADE: Delete worker_assignments first
    await supabase.from("worker_assignment").delete().eq("worker_id", id)

    // Delete worker
    const { error } = await supabase.from("worker").delete().eq("worker_id", id)

    if (error) throw error
    return NextResponse.json({ success: true })
  } catch (error: any) {
    return NextResponse.json({ error: error.message }, { status: 500 })
  }
}
