import { type NextRequest, NextResponse } from "next/server"
import { createClient } from "@/lib/supabase/server"

export async function GET(req: NextRequest) {
  try {
    const supabase = await createClient()
    const { data, error } = await supabase.from("amenity").select("*").order("amenity_id")

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
      .from("amenity")
      .select("amenity_id")
      .order("amenity_id", { ascending: false })
      .limit(1)
    
    const newId = maxData && maxData.length > 0 ? maxData[0].amenity_id + 1 : 1

    const { data, error } = await supabase
      .from("amenity")
      .insert([{ ...body, amenity_id: newId, is_active: true }])
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
    const { amenity_id, ...updates } = body

    const { data, error } = await supabase.from("amenity").update(updates).eq("amenity_id", amenity_id).select()

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

    // CASCADE: Delete building_amenity and apt_unit_amenity first
    await supabase.from("building_amenity").delete().eq("amenity_id", id)
    await supabase.from("apt_unit_amenity").delete().eq("amenity_id", id)

    // Delete amenity
    const { error } = await supabase.from("amenity").delete().eq("amenity_id", id)

    if (error) throw error
    return NextResponse.json({ success: true })
  } catch (error: any) {
    return NextResponse.json({ error: error.message }, { status: 500 })
  }
}
