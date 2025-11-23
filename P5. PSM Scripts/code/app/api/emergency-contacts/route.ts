import { type NextRequest, NextResponse } from "next/server"
import { createClient } from "@/lib/supabase/server"

export async function GET(req: NextRequest) {
  try {
    const supabase = await createClient()
    const { data, error } = await supabase.from("emergency_contact").select("*").order("contact_id")

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
      .from("emergency_contact")
      .select("contact_id")
      .order("contact_id", { ascending: false })
      .limit(1)
    
    const newContactId = maxData && maxData.length > 0 ? maxData[0].contact_id + 1 : 1

    const { data, error } = await supabase
      .from("emergency_contact")
      .insert([{ ...body, contact_id: newContactId }])
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
    const { contact_id, ...updates } = body

    const { data, error } = await supabase
      .from("emergency_contact")
      .update(updates)
      .eq("contact_id", contact_id)
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

    const { error } = await supabase.from("emergency_contact").delete().eq("contact_id", id)

    if (error) throw error
    return NextResponse.json({ success: true })
  } catch (error: any) {
    return NextResponse.json({ error: error.message }, { status: 500 })
  }
}
