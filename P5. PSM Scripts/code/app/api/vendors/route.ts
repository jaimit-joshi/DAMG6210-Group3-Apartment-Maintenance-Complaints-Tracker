import { createClient } from "@/lib/supabase/server"
import { type NextRequest, NextResponse } from "next/server"

function convertVendorData(data: any) {
  return {
    VendorID: data.vendor_id,
    CompanyName: data.company_name,
    TaxID: data.tax_id,
    PrimaryContactName: data.primary_contact_name,
    PhoneNumber: data.phone_number,
    EmailAddress: data.email_address,
    StreetAddress: data.street_address,
    City: data.city,
    State: data.state,
    ZipCode: data.zip_code,
    LicenseNumber: data.license_number,
    LicenseExpiryDate: data.license_expiry_date,
    InsurancePolicyNumber: data.insurance_policy_number,
    InsuranceExpiryDate: data.insurance_expiry_date,
    VendorStatus: data.vendor_status,
    IsPreferred: data.is_preferred,
  }
}

export async function GET(req: NextRequest) {
  try {
    console.log("[v0] GET /api/vendors - Fetching vendors")
    const supabase = await createClient()
    const { data, error } = await supabase.from("vendor_company").select("*").order("vendor_id", { ascending: true })

    if (error) throw error
    const convertedData = data?.map(convertVendorData) || []
    return NextResponse.json(convertedData)
  } catch (error) {
    console.error("[v0] Error:", error)
    return NextResponse.json({ error: "Failed to fetch vendors" }, { status: 500 })
  }
}

export async function POST(req: NextRequest) {
  try {
    const body = await req.json()
    const {
      CompanyName,
      TaxID,
      PrimaryContactName,
      PhoneNumber,
      EmailAddress,
      StreetAddress,
      City,
      State,
      ZipCode,
      LicenseNumber,
      LicenseExpiryDate,
      InsurancePolicyNumber,
      InsuranceExpiryDate,
      VendorStatus,
      IsPreferred,
    } = body

    const supabase = await createClient()
    
    const { data: maxData } = await supabase
      .from("vendor_company")
      .select("vendor_id")
      .order("vendor_id", { ascending: false })
      .limit(1)
    
    const nextId = maxData && maxData.length > 0 ? maxData[0].vendor_id + 1 : 1

    const { data, error } = await supabase
      .from("vendor_company")
      .insert({
        vendor_id: nextId, // Using auto-generated ID
        company_name: CompanyName,
        tax_id: TaxID,
        primary_contact_name: PrimaryContactName,
        phone_number: PhoneNumber,
        email_address: EmailAddress,
        street_address: StreetAddress,
        city: City,
        state: State,
        zip_code: ZipCode,
        license_number: LicenseNumber || null,
        license_expiry_date: LicenseExpiryDate || null,
        insurance_policy_number: InsurancePolicyNumber || null,
        insurance_expiry_date: InsuranceExpiryDate || null,
        vendor_status: VendorStatus || "Active",
        is_preferred: IsPreferred || false,
      })
      .select()

    if (error) throw error
    const convertedData = data?.[0] ? convertVendorData(data[0]) : null
    return NextResponse.json({ message: "Vendor created successfully", data: convertedData }, { status: 201 })
  } catch (error) {
    console.error("[v0] Error:", error)
    return NextResponse.json({ error: "Failed to create vendor" }, { status: 500 })
  }
}

export async function PUT(req: NextRequest) {
  try {
    const body = await req.json()
    const { VendorID, ...updateData } = body

    const updates: Record<string, any> = {}
    if (updateData.CompanyName) updates.company_name = updateData.CompanyName
    if (updateData.VendorStatus) updates.vendor_status = updateData.VendorStatus
    if (updateData.IsPreferred !== undefined) updates.is_preferred = updateData.IsPreferred

    const supabase = await createClient()
    const { data, error } = await supabase.from("vendor_company").update(updates).eq("vendor_id", VendorID).select()

    if (error) throw error
    const convertedData = data?.[0] ? convertVendorData(data[0]) : null
    return NextResponse.json({ message: "Vendor updated successfully", data: convertedData })
  } catch (error) {
    console.error("[v0] Error:", error)
    return NextResponse.json({ error: "Failed to update vendor" }, { status: 500 })
  }
}

export async function DELETE(req: NextRequest) {
  try {
    const { searchParams } = new URL(req.url)
    const vendorId = searchParams.get("id")

    if (!vendorId) {
      return NextResponse.json({ error: "Vendor ID is required" }, { status: 400 })
    }

    const supabase = await createClient()
    const id = Number.parseInt(vendorId)

    // Delete workers
    await supabase.from("worker").delete().eq("vendor_id", id)

    // Delete work orders
    await supabase.from("work_order").delete().eq("vendor_id", id)

    // Delete invoices
    await supabase.from("invoice").delete().eq("vendor_id", id)

    // Now delete the vendor
    const { error } = await supabase.from("vendor_company").delete().eq("vendor_id", id)

    if (error) {
      console.error("[v0] Error:", error)
      return NextResponse.json({ error: error.message }, { status: 500 })
    }

    return NextResponse.json({ message: "Vendor deleted successfully" })
  } catch (error) {
    console.error("[v0] Error:", error)
    return NextResponse.json({ error: "Failed to delete vendor" }, { status: 500 })
  }
}
