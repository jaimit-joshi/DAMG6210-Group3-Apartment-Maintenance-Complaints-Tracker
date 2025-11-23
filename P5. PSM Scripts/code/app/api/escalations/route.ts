import { type NextRequest, NextResponse } from "next/server"
import { createClient } from "@/lib/supabase/server"

export async function GET(req: NextRequest) {
  try {
    const supabase = await createClient()
    const { data, error } = await supabase.from("escalation").select("*").order("escalation_id")

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

    // Get max escalation_id and increment by 1 for auto-generated ID
    const { data: maxData } = await supabase
      .from("escalation")
      .select("escalation_id")
      .order("escalation_id", { ascending: false })
      .limit(1)
    
    const newId = maxData && maxData.length > 0 ? maxData[0].escalation_id + 1 : 1

    const { data, error } = await supabase
      .from("escalation")
      .insert([{ 
        ...body, 
        escalation_id: newId,
        escalation_date: new Date().toISOString(),
        escalation_status: "Open"
      }])
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
    const { escalation_id, ...updates } = body

    const { data, error } = await supabase
      .from("escalation")
      .update(updates)
      .eq("escalation_id", escalation_id)
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

    const { error } = await supabase.from("escalation").delete().eq("escalation_id", id)

    if (error) throw error
    return NextResponse.json({ success: true })
  } catch (error: any) {
    return NextResponse.json({ error: error.message }, { status: 500 })
  }
}
