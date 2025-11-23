import { createClient } from "@/lib/supabase/server"
import { type NextRequest, NextResponse } from "next/server"

function convertManagerData(data: any) {
  return {
    ManagerID: data.manager_id,
    EmployeeID: data.employee_id,
    FirstName: data.first_name,
    LastName: data.last_name,
    EmailAddress: data.email_address,
    PhoneNumber: data.phone_number,
    JobTitle: data.job_title,
    Department: data.department,
    HireDate: data.hire_date,
    ManagerRole: data.manager_role,
    MaxApprovalLimit: data.max_approval_limit,
    AccountStatus: data.account_status,
  }
}

export async function GET(req: NextRequest) {
  try {
    console.log("[v0] GET /api/managers - Fetching managers")
    const supabase = await createClient()
    const { data, error } = await supabase.from("property_manager").select("*").order("manager_id", { ascending: true })

    if (error) throw error
    const convertedData = data?.map(convertManagerData) || []
    return NextResponse.json(convertedData)
  } catch (error) {
    console.error("[v0] Error:", error)
    return NextResponse.json({ error: "Failed to fetch managers" }, { status: 500 })
  }
}

export async function POST(req: NextRequest) {
  try {
    const body = await req.json()
    const {
      EmployeeID,
      FirstName,
      LastName,
      EmailAddress,
      PhoneNumber,
      JobTitle,
      Department,
      HireDate,
      ManagerRole,
      MaxApprovalLimit,
      AccountStatus,
    } = body

    const supabase = await createClient()
    
    const { data: maxData } = await supabase
      .from("property_manager")
      .select("manager_id")
      .order("manager_id", { ascending: false })
      .limit(1)
    
    const nextId = maxData && maxData.length > 0 ? maxData[0].manager_id + 1 : 1

    const { data, error } = await supabase
      .from("property_manager")
      .insert([
        {
          manager_id: nextId, // Using auto-generated ID
          employee_id: EmployeeID,
          first_name: FirstName,
          last_name: LastName,
          email_address: EmailAddress,
          phone_number: PhoneNumber,
          job_title: JobTitle,
          department: Department || null,
          hire_date: HireDate,
          manager_role: ManagerRole || "Manager",
          max_approval_limit: MaxApprovalLimit || null,
          account_status: AccountStatus || "Active",
        },
      ])
      .select()

    if (error) throw error
    const convertedData = data?.[0] ? convertManagerData(data[0]) : null
    return NextResponse.json({ message: "Manager created successfully", data: convertedData }, { status: 201 })
  } catch (error) {
    console.error("[v0] Error:", error)
    return NextResponse.json({ error: "Failed to create manager" }, { status: 500 })
  }
}

export async function PUT(req: NextRequest) {
  try {
    const body = await req.json()
    const { ManagerID, ...updateData } = body

    const updates: Record<string, any> = {}
    if (updateData.JobTitle) updates.job_title = updateData.JobTitle
    if (updateData.AccountStatus) updates.account_status = updateData.AccountStatus

    const supabase = await createClient()
    const { data, error } = await supabase.from("property_manager").update(updates).eq("manager_id", ManagerID).select()

    if (error) throw error
    const convertedData = data?.[0] ? convertManagerData(data[0]) : null
    return NextResponse.json({ message: "Manager updated successfully", data: convertedData })
  } catch (error) {
    console.error("[v0] Error:", error)
    return NextResponse.json({ error: "Failed to update manager" }, { status: 500 })
  }
}

export async function DELETE(req: NextRequest) {
  try {
    const { searchParams } = new URL(req.url)
    const managerId = searchParams.get("id")

    if (!managerId) {
      return NextResponse.json({ error: "Manager ID is required" }, { status: 400 })
    }

    const supabase = await createClient()
    const id = Number.parseInt(managerId)

    // Delete building manager assignments
    await supabase.from("building_manager_assignment").delete().eq("manager_id", id)

    // Nullify references in leases (set prepared_by_manager_id to null)
    await supabase.from("lease").update({ prepared_by_manager_id: null }).eq("prepared_by_manager_id", id)

    // Nullify references in work orders
    await supabase.from("work_order").update({ created_by_manager_id: null }).eq("created_by_manager_id", id)
    await supabase.from("work_order").update({ approved_by_manager_id: null }).eq("approved_by_manager_id", id)

    // Nullify references in invoices
    await supabase.from("invoice").update({ approved_by_manager_id: null }).eq("approved_by_manager_id", id)

    // Delete escalations
    await supabase.from("escalation").delete().eq("escalated_by_manager_id", id)

    // Now delete the manager
    const { error } = await supabase.from("property_manager").delete().eq("manager_id", id)

    if (error) {
      console.error("[v0] Error:", error)
      return NextResponse.json({ error: error.message }, { status: 500 })
    }

    return NextResponse.json({ message: "Manager deleted successfully" })
  } catch (error) {
    console.error("[v0] Error:", error)
    return NextResponse.json({ error: "Failed to delete manager" }, { status: 500 })
  }
}
