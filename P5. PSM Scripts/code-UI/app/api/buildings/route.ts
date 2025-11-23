import { createClient } from "@/lib/supabase/server"
import { type NextRequest, NextResponse } from "next/server"

export async function GET(req: NextRequest) {
  try {
    console.log("[v0] GET /api/buildings - Fetching buildings")

    const supabase = await createClient()

    const { data, error } = await supabase.from("building").select("*").order("building_id", { ascending: true })

    if (error) {
      console.error("[v0] Supabase error:", error)
      return NextResponse.json({ error: error.message }, { status: 500 })
    }

    const convertedData = (data || []).map((row: any) => ({
      BuildingID: row.building_id,
      BuildingName: row.building_name,
      StreetAddress: row.street_address,
      City: row.city,
      State: row.state,
      ZipCode: row.zip_code,
      YearBuilt: row.year_built,
      NumberOfFloors: row.number_of_floors,
      TotalUnits: row.total_units,
      BuildingType: row.building_type,
      HasElevator: row.has_elevator,
    }))

    console.log("[v0] Successfully fetched", convertedData.length, "buildings")
    return NextResponse.json(convertedData)
  } catch (error) {
    console.error("[v0] Error fetching buildings:", error)
    return NextResponse.json({ error: "Failed to fetch buildings" }, { status: 500 })
  }
}

export async function POST(req: NextRequest) {
  try {
    const body = await req.json()
    const {
      BuildingName,
      StreetAddress,
      City,
      State,
      ZipCode,
      YearBuilt,
      NumberOfFloors,
      TotalUnits,
      BuildingType,
      HasElevator,
    } = body

    console.log("[v0] POST /api/buildings - Creating building:", BuildingName)

    const supabase = await createClient()

    const { data: maxData } = await supabase
      .from("building")
      .select("building_id")
      .order("building_id", { ascending: false })
      .limit(1)

    const nextId = maxData && maxData.length > 0 ? maxData[0].building_id + 1 : 1

    const { data, error } = await supabase
      .from("building")
      .insert({
        building_id: nextId,
        building_name: BuildingName,
        street_address: StreetAddress,
        city: City,
        state: State,
        zip_code: ZipCode,
        year_built: YearBuilt,
        number_of_floors: NumberOfFloors,
        total_units: TotalUnits,
        building_type: BuildingType,
        has_elevator: HasElevator || false,
      })
      .select()

    if (error) {
      console.error("[v0] Supabase error:", error)
      return NextResponse.json({ error: error.message }, { status: 500 })
    }

    console.log("[v0] Building created successfully with ID:", nextId)
    return NextResponse.json({ message: "Building created successfully", data }, { status: 201 })
  } catch (error) {
    console.error("[v0] Error creating building:", error)
    return NextResponse.json({ error: "Failed to create building" }, { status: 500 })
  }
}

export async function PUT(req: NextRequest) {
  try {
    const body = await req.json()
    const {
      BuildingID,
      BuildingName,
      StreetAddress,
      City,
      State,
      ZipCode,
      YearBuilt,
      NumberOfFloors,
      TotalUnits,
      BuildingType,
      HasElevator,
    } = body

    const updates: Record<string, any> = {}
    if (BuildingName) updates.building_name = BuildingName
    if (StreetAddress) updates.street_address = StreetAddress
    if (City) updates.city = City
    if (State) updates.state = State
    if (ZipCode) updates.zip_code = ZipCode
    if (YearBuilt) updates.year_built = YearBuilt
    if (NumberOfFloors) updates.number_of_floors = NumberOfFloors
    if (TotalUnits) updates.total_units = TotalUnits
    if (BuildingType) updates.building_type = BuildingType
    if (HasElevator !== undefined) updates.has_elevator = HasElevator
    updates.modified_date = new Date().toISOString()

    console.log("[v0] PUT /api/buildings - Updating building:", BuildingID)

    const supabase = await createClient()

    const { data, error } = await supabase.from("building").update(updates).eq("building_id", BuildingID).select()

    if (error) {
      console.error("[v0] Supabase error:", error)
      return NextResponse.json({ error: error.message }, { status: 500 })
    }

    console.log("[v0] Building updated successfully")
    return NextResponse.json({ message: "Building updated successfully", data })
  } catch (error) {
    console.error("[v0] Error updating building:", error)
    return NextResponse.json({ error: "Failed to update building" }, { status: 500 })
  }
}

export async function DELETE(req: NextRequest) {
  try {
    const { searchParams } = new URL(req.url)
    const buildingId = searchParams.get("id")

    if (!buildingId) {
      return NextResponse.json({ error: "Building ID is required" }, { status: 400 })
    }

    const supabase = await createClient()
    const id = Number.parseInt(buildingId)

    // Delete building amenities
    await supabase.from("building_amenity").delete().eq("building_id", id)

    // Delete building manager assignments
    await supabase.from("building_manager_assignment").delete().eq("building_id", id)

    // Get all units in this building to cascade further
    const { data: units } = await supabase.from("apartment_unit").select("unit_id").eq("building_id", id)

    if (units && units.length > 0) {
      const unitIds = units.map((u) => u.unit_id)

      // Delete unit amenities
      await supabase.from("apt_unit_amenity").delete().in("unit_id", unitIds)

      // Delete leases for these units
      await supabase.from("lease").delete().in("unit_id", unitIds)

      // Delete maintenance requests for these units
      await supabase.from("maintenance_request").delete().in("unit_id", unitIds)

      // Delete work orders for these units
      await supabase.from("work_order").delete().in("unit_id", unitIds)
    }

    // Delete apartment units
    await supabase.from("apartment_unit").delete().eq("building_id", id)

    // Now delete the building
    const { error: deleteError } = await supabase.from("building").delete().eq("building_id", id)

    if (deleteError) {
      console.error("[v0] Supabase error:", deleteError)
      return NextResponse.json({ error: deleteError.message }, { status: 500 })
    }

    return NextResponse.json({ message: "Building deleted successfully" })
  } catch (error) {
    console.error("[v0] Error deleting building:", error)
    return NextResponse.json({ error: "Failed to delete building" }, { status: 500 })
  }
}
