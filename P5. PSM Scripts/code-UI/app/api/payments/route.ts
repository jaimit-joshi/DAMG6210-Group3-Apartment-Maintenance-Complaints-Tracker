import { createClient } from "@/lib/supabase/server"
import { type NextRequest, NextResponse } from "next/server"

function convertPaymentData(data: any) {
  return {
    TransactionID: data.transaction_id,
    LeaseID: data.lease_id,
    ResidentID: data.resident_id,
    TransactionType: data.transaction_type,
    TransactionDate: data.transaction_date,
    DueDate: data.due_date,
    AmountDue: data.amount_due,
    AmountPaid: data.amount_paid,
    PaymentMethod: data.payment_method,
    ReferenceNumber: data.reference_number,
    TransactionStatus: data.transaction_status,
  }
}

export async function GET(req: NextRequest) {
  try {
    console.log("[v0] GET /api/payments - Fetching payments")
    const supabase = await createClient()
    const { data, error } = await supabase
      .from("payment_transaction")
      .select("*")
      .order("transaction_id", { ascending: true })

    if (error) throw error
    const convertedData = data?.map(convertPaymentData) || []
    return NextResponse.json(convertedData)
  } catch (error) {
    console.error("[v0] Error:", error)
    return NextResponse.json({ error: "Failed to fetch payments" }, { status: 500 })
  }
}

export async function POST(req: NextRequest) {
  try {
    const body = await req.json()
    const {
      LeaseID,
      ResidentID,
      TransactionType,
      TransactionDate,
      DueDate,
      AmountDue,
      AmountPaid,
      PaymentMethod,
      ReferenceNumber,
      TransactionStatus,
    } = body

    const supabase = await createClient()
    
    const { data: maxData } = await supabase
      .from("payment_transaction")
      .select("transaction_id")
      .order("transaction_id", { ascending: false })
      .limit(1)
    
    const newTransactionId = maxData && maxData.length > 0 ? maxData[0].transaction_id + 1 : 1
    
    const { data, error } = await supabase
      .from("payment_transaction")
      .insert([
        {
          transaction_id: newTransactionId,
          lease_id: LeaseID,
          resident_id: ResidentID,
          transaction_type: TransactionType || "Rent Payment",
          transaction_date: TransactionDate,
          due_date: DueDate || null,
          amount_due: AmountDue || 0,
          amount_paid: AmountPaid,
          payment_method: PaymentMethod,
          reference_number: ReferenceNumber || null,
          transaction_status: TransactionStatus || "Completed",
        },
      ])
      .select()

    if (error) throw error
    const convertedData = data?.[0] ? convertPaymentData(data[0]) : null
    return NextResponse.json({ message: "Payment recorded successfully", data: convertedData }, { status: 201 })
  } catch (error) {
    console.error("[v0] Error:", error)
    return NextResponse.json({ error: "Failed to create payment" }, { status: 500 })
  }
}

export async function PUT(req: NextRequest) {
  try {
    const body = await req.json()
    const { TransactionID, ...updateData } = body

    const updates: Record<string, any> = {}
    if (updateData.TransactionStatus) updates.transaction_status = updateData.TransactionStatus

    const supabase = await createClient()
    const { data, error } = await supabase
      .from("payment_transaction")
      .update(updates)
      .eq("transaction_id", TransactionID)
      .select()

    if (error) throw error
    const convertedData = data?.[0] ? convertPaymentData(data[0]) : null
    return NextResponse.json({ message: "Payment updated successfully", data: convertedData })
  } catch (error) {
    console.error("[v0] Error:", error)
    return NextResponse.json({ error: "Failed to update payment" }, { status: 500 })
  }
}

export async function DELETE(req: NextRequest) {
  try {
    const { searchParams } = new URL(req.url)
    const transactionId = searchParams.get("id")

    if (!transactionId) {
      return NextResponse.json({ error: "Transaction ID is required" }, { status: 400 })
    }

    const supabase = await createClient()

    const { error } = await supabase.from("payment_transaction").delete().eq("transaction_id", transactionId)

    if (error) {
      console.error("[v0] Error:", error)
      return NextResponse.json({ error: error.message }, { status: 500 })
    }

    return NextResponse.json({ message: "Payment deleted successfully" })
  } catch (error) {
    console.error("[v0] Error:", error)
    return NextResponse.json({ error: "Failed to delete payment" }, { status: 500 })
  }
}
