import { createClient } from "@/lib/supabase/server"
import { type NextRequest, NextResponse } from "next/server"

function convertUnitData(data: any) {
  return {
    UnitID: data.unit_id,
    BuildingID: data.building_id,
    UnitNumber: data.unit_number,
    FloorNumber: data.floor_number,
    UnitType: data.unit_type,
    SquareFootage: data.square_footage,
    NumberBedrooms: data.number_bedrooms,
    NumberBathrooms: data.number_bathrooms,
    BaseRentAmount: data.base_rent_amount,
    UnitStatus: data.unit_status,
  }
}

export async function GET(req: NextRequest) {
  try {
    console.log("[v0] GET /api/units - Fetching units")
    const supabase = await createClient()
    const { data, error } = await supabase.from("apartment_unit").select("*").order("unit_id", { ascending: true })

    if (error) throw error
    const convertedData = data?.map(convertUnitData) || []
    return NextResponse.json(convertedData)
  } catch (error) {
    console.error("[v0] Error:", error)
    return NextResponse.json({ error: "Failed to fetch units" }, { status: 500 })
  }
}

export async function POST(req: NextRequest) {
  try {
    const body = await req.json()
    console.log("[v0] POST /api/units - Request body:", body)

    const {
      BuildingID,
      UnitNumber,
      FloorNumber,
      UnitType,
      SquareFootage,
      NumberBedrooms,
      NumberBathrooms,
      BaseRentAmount,
      UnitStatus,
    } = body

    const supabase = await createClient()

    const { data: maxData } = await supabase
      .from("apartment_unit")
      .select("unit_id")
      .order("unit_id", { ascending: false })
      .limit(1)

    const nextId = maxData && maxData.length > 0 ? maxData[0].unit_id + 1 : 1

    const { data, error } = await supabase
      .from("apartment_unit")
      .insert({
        unit_id: nextId,
        building_id: BuildingID,
        unit_number: UnitNumber,
        floor_number: FloorNumber,
        unit_type: UnitType,
        square_footage: SquareFootage,
        number_bedrooms: NumberBedrooms,
        number_bathrooms: NumberBathrooms,
        base_rent_amount: BaseRentAmount,
        unit_status: UnitStatus || "Available",
      })
      .select()

    if (error) {
      console.error("[v0] Error creating unit:", error)
      throw error
    }

    console.log("[v0] Unit created successfully with ID:", nextId)
    const convertedData = data?.[0] ? convertUnitData(data[0]) : null
    return NextResponse.json({ message: "Unit created successfully", data: convertedData }, { status: 201 })
  } catch (error: any) {
    console.error("[v0] Error:", error)
    return NextResponse.json({ error: error.message || "Failed to create unit" }, { status: 500 })
  }
}

export async function PUT(req: NextRequest) {
  try {
    const body = await req.json()
    const { UnitID, ...updateData } = body

    const updates: Record<string, any> = {}
    if (updateData.UnitNumber) updates.unit_number = updateData.UnitNumber
    if (updateData.FloorNumber) updates.floor_number = updateData.FloorNumber
    if (updateData.UnitType) updates.unit_type = updateData.UnitType
    if (updateData.SquareFootage) updates.square_footage = updateData.SquareFootage
    if (updateData.NumberBedrooms) updates.number_bedrooms = updateData.NumberBedrooms
    if (updateData.NumberBathrooms) updates.number_bathrooms = updateData.NumberBathrooms
    if (updateData.BaseRentAmount) updates.base_rent_amount = updateData.BaseRentAmount
    if (updateData.UnitStatus) updates.unit_status = updateData.UnitStatus

    const supabase = await createClient()
    const { data, error } = await supabase.from("apartment_unit").update(updates).eq("unit_id", UnitID).select()

    if (error) throw error
    const convertedData = data?.[0] ? convertUnitData(data[0]) : null
    return NextResponse.json({ message: "Unit updated successfully", data: convertedData })
  } catch (error) {
    console.error("[v0] Error:", error)
    return NextResponse.json({ error: "Failed to update unit" }, { status: 500 })
  }
}

export async function DELETE(req: NextRequest) {
  try {
    const { searchParams } = new URL(req.url)
    const unitId = searchParams.get("id")

    if (!unitId) {
      return NextResponse.json({ error: "Unit ID is required" }, { status: 400 })
    }

    const supabase = await createClient()
    const id = Number.parseInt(unitId)

    // Delete unit amenities
    await supabase.from("apt_unit_amenity").delete().eq("unit_id", id)

    // Delete leases
    await supabase.from("lease").delete().eq("unit_id", id)

    // Delete maintenance requests
    await supabase.from("maintenance_request").delete().eq("unit_id", id)

    // Delete work orders
    await supabase.from("work_order").delete().eq("unit_id", id)

    // Now delete the unit
    const { error } = await supabase.from("apartment_unit").delete().eq("unit_id", id)

    if (error) {
      console.error("[v0] Error:", error)
      return NextResponse.json({ error: error.message }, { status: 500 })
    }

    return NextResponse.json({ message: "Unit deleted successfully" })
  } catch (error) {
    console.error("[v0] Error:", error)
    return NextResponse.json({ error: "Failed to delete unit" }, { status: 500 })
  }
}
