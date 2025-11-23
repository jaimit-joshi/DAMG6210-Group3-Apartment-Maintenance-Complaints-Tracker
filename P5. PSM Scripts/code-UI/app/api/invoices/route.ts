import { createClient } from "@/lib/supabase/server"
import { type NextRequest, NextResponse } from "next/server"

function convertInvoiceData(data: any) {
  return {
    InvoiceID: data.invoice_id,
    InvoiceNumber: data.invoice_number,
    WorkOrderID: data.work_order_id,
    VendorID: data.vendor_id,
    ApprovedByManagerID: data.approved_by_manager_id,
    InvoiceDate: data.invoice_date,
    DueDate: data.due_date,
    LaborCost: data.labor_cost,
    MaterialCost: data.material_cost,
    TaxAmount: data.tax_amount,
    TotalAmount: data.total_amount,
    PaymentStatus: data.payment_status,
  }
}

export async function GET(req: NextRequest) {
  try {
    console.log("[v0] GET /api/invoices - Fetching invoices")
    const supabase = await createClient()
    const { data, error } = await supabase.from("invoice").select("*").order("invoice_id", { ascending: true })

    if (error) throw error
    const convertedData = data?.map(convertInvoiceData) || []
    return NextResponse.json(convertedData)
  } catch (error) {
    console.error("[v0] Error:", error)
    return NextResponse.json({ error: "Failed to fetch invoices" }, { status: 500 })
  }
}

export async function POST(req: NextRequest) {
  try {
    const body = await req.json()
    const {
      InvoiceNumber,
      WorkOrderID,
      VendorID,
      ApprovedByManagerID,
      InvoiceDate,
      DueDate,
      LaborCost,
      MaterialCost,
      TaxAmount,
      TotalAmount,
      PaymentStatus,
    } = body

    const supabase = await createClient()
    const { data, error } = await supabase
      .from("invoice")
      .insert([
        {
          invoice_number: InvoiceNumber,
          work_order_id: WorkOrderID,
          vendor_id: VendorID,
          approved_by_manager_id: ApprovedByManagerID || null,
          invoice_date: InvoiceDate,
          due_date: DueDate,
          labor_cost: LaborCost || 0,
          material_cost: MaterialCost || 0,
          tax_amount: TaxAmount || 0,
          total_amount: TotalAmount,
          payment_status: PaymentStatus || "Pending",
        },
      ])
      .select()

    if (error) throw error
    const convertedData = data?.[0] ? convertInvoiceData(data[0]) : null
    return NextResponse.json({ message: "Invoice created successfully", data: convertedData }, { status: 201 })
  } catch (error) {
    console.error("[v0] Error:", error)
    return NextResponse.json({ error: "Failed to create invoice" }, { status: 500 })
  }
}

export async function PUT(req: NextRequest) {
  try {
    const body = await req.json()
    const { InvoiceID, ...updateData } = body

    const updates: Record<string, any> = {}
    if (updateData.PaymentStatus) updates.payment_status = updateData.PaymentStatus

    const supabase = await createClient()
    const { data, error } = await supabase.from("invoice").update(updates).eq("invoice_id", InvoiceID).select()

    if (error) throw error
    const convertedData = data?.[0] ? convertInvoiceData(data[0]) : null
    return NextResponse.json({ message: "Invoice updated successfully", data: convertedData })
  } catch (error) {
    console.error("[v0] Error:", error)
    return NextResponse.json({ error: "Failed to update invoice" }, { status: 500 })
  }
}

export async function DELETE(req: NextRequest) {
  try {
    const { searchParams } = new URL(req.url)
    const invoiceId = searchParams.get("id")

    if (!invoiceId) {
      return NextResponse.json({ error: "Invoice ID is required" }, { status: 400 })
    }

    const supabase = await createClient()

    const { error } = await supabase.from("invoice").delete().eq("invoice_id", invoiceId)

    if (error) {
      console.error("[v0] Error:", error)
      return NextResponse.json({ error: error.message }, { status: 500 })
    }

    return NextResponse.json({ message: "Invoice deleted successfully" })
  } catch (error) {
    console.error("[v0] Error:", error)
    return NextResponse.json({ error: "Failed to delete invoice" }, { status: 500 })
  }
}
