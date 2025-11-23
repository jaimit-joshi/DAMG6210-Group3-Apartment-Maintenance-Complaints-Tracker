import { type NextRequest, NextResponse } from "next/server"
import { createClient } from "@/lib/supabase/server"

export async function GET(req: NextRequest) {
  try {
    const supabase = await createClient()
    const { data, error } = await supabase.from("apt_unit_amenity").select("*").order("unit_amenity_id")

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
      .from("apt_unit_amenity")
      .select("unit_amenity_id")
      .order("unit_amenity_id", { ascending: false })
      .limit(1)
    
    const newId = maxData && maxData.length > 0 ? maxData[0].unit_amenity_id + 1 : 1

    const { data, error } = await supabase
      .from("apt_unit_amenity")
      .insert([{ ...body, unit_amenity_id: newId }])
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
    const { unit_amenity_id, ...updates } = body

    const { data, error } = await supabase
      .from("apt_unit_amenity")
      .update(updates)
      .eq("unit_amenity_id", unit_amenity_id)
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

    const { error } = await supabase.from("apt_unit_amenity").delete().eq("unit_amenity_id", id)

    if (error) throw error
    return NextResponse.json({ success: true })
  } catch (error: any) {
    return NextResponse.json({ error: error.message }, { status: 500 })
  }
}
