"use client"

import { useState, useEffect } from "react"
import DataTable from "@/components/data-table"
import FormModal from "@/components/form-modal"
import type { PaymentTransaction } from "@/lib/types"

const columns = [
  { key: "TransactionID", label: "ID", sortable: true },
  { key: "LeaseID", label: "Lease", sortable: true },
  { key: "ResidentID", label: "Resident", sortable: true },
  { key: "TransactionType", label: "Type" },
  { key: "TransactionDate", label: "Date" },
  { key: "DueDate", label: "Due Date" },
  { key: "AmountDue", label: "Amount Due" },
  { key: "AmountPaid", label: "Amount Paid" },
  { key: "PaymentMethod", label: "Method" },
  { key: "ReferenceNumber", label: "Reference" },
  { key: "TransactionStatus", label: "Status" },
]

const formFields = [
  { name: "LeaseID", label: "Lease", type: "select" as const, required: true, endpoint: "/api/leases" },
  { name: "ResidentID", label: "Resident", type: "select" as const, required: true, endpoint: "/api/residents" },
  {
    name: "TransactionType",
    label: "Transaction Type",
    type: "select" as const,
    required: true,
    options: [
      { value: "Rent Payment", label: "Rent Payment" },
      { value: "Deposit", label: "Deposit" },
      { value: "Late Fee", label: "Late Fee" },
      { value: "Refund", label: "Refund" },
      { value: "Other", label: "Other" },
    ],
  },
  { name: "TransactionDate", label: "Transaction Date", type: "date" as const, required: true },
  { name: "DueDate", label: "Due Date", type: "date" as const },
  { name: "AmountDue", label: "Amount Due", type: "number" as const, step: "0.01" },
  { name: "AmountPaid", label: "Amount Paid", type: "number" as const, required: true, step: "0.01" },
  {
    name: "PaymentMethod",
    label: "Payment Method",
    type: "select" as const,
    required: true,
    options: [
      { value: "Check", label: "Check" },
      { value: "ACH", label: "ACH" },
      { value: "Credit Card", label: "Credit Card" },
      { value: "Cash", label: "Cash" },
      { value: "Wire Transfer", label: "Wire Transfer" },
      { value: "Online Portal", label: "Online Portal" },
    ],
  },
  { name: "ReferenceNumber", label: "Reference Number", type: "text" as const },
  {
    name: "TransactionStatus",
    label: "Status",
    type: "select" as const,
    required: true,
    options: [
      { value: "Pending", label: "Pending" },
      { value: "Completed", label: "Completed" },
      { value: "Failed", label: "Failed" },
      { value: "Cancelled", label: "Cancelled" },
    ],
  },
]

export default function PaymentsPage() {
  const [payments, setPayments] = useState<PaymentTransaction[]>([])
  const [isModalOpen, setIsModalOpen] = useState(false)
  const [selectedPayment, setSelectedPayment] = useState<PaymentTransaction | null>(null)
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    fetchPayments()
  }, [])

  async function fetchPayments() {
    try {
      const response = await fetch("/api/payments")
      const data = await response.json()
      setPayments(data)
    } catch (error) {
      console.error("Error fetching payments:", error)
    }
  }

  const handleAdd = () => {
    setSelectedPayment(null)
    setIsModalOpen(true)
  }

  const handleEdit = (payment: PaymentTransaction) => {
    setSelectedPayment(payment)
    setIsModalOpen(true)
  }

  const handleDelete = async (payment: PaymentTransaction) => {
    if (confirm(`Delete payment ${payment.TransactionID}?`)) {
      try {
        const response = await fetch(`/api/payments?id=${payment.TransactionID}`, {
          method: "DELETE",
        })

        if (response.ok) {
          await fetchPayments()
        } else {
          const data = await response.json()
          alert(`Error: ${data.error}`)
        }
      } catch (error) {
        alert("Error deleting payment")
      }
    }
  }

  const handleSubmit = async (data: any) => {
    setLoading(true)
    try {
      const isEdit = selectedPayment && selectedPayment.TransactionID
      const method = isEdit ? "PUT" : "POST"
      const url = "/api/payments"

      const payload: any = { ...data }
      if (isEdit) {
        payload.TransactionID = selectedPayment.TransactionID
      }

      const response = await fetch(url, {
        method,
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload),
      })

      if (response.ok) {
        await fetchPayments()
        setIsModalOpen(false)
      } else {
        const errorData = await response.json()
        alert(`Error: ${errorData.error}`)
      }
    } catch (error) {
      alert("Error saving payment")
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold text-foreground">Payments</h1>
        <p className="text-gray-600 mt-1">Track resident rent and fee payments</p>
      </div>

      <DataTable
        columns={columns}
        data={payments}
        onEdit={handleEdit}
        onDelete={handleDelete}
        onAdd={handleAdd}
        title="Payments List"
      />

      <FormModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        onSubmit={handleSubmit}
        title={selectedPayment ? "Edit Payment" : "Add Payment"}
        fields={formFields}
        initialData={selectedPayment}
        loading={loading}
      />
    </div>
  )
}
