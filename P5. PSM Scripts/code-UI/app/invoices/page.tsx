"use client"

import { useState, useEffect } from "react"
import DataTable from "@/components/data-table"
import FormModal from "@/components/form-modal"
import type { Invoice } from "@/lib/types"

const columns = [
  { key: "InvoiceID", label: "ID", sortable: true },
  { key: "InvoiceNumber", label: "Invoice #", sortable: true },
  { key: "WorkOrderID", label: "Work Order", sortable: true },
  { key: "VendorID", label: "Vendor" },
  { key: "ApprovedByManagerID", label: "Approved By" },
  { key: "InvoiceDate", label: "Date" },
  { key: "DueDate", label: "Due Date" },
  { key: "LaborCost", label: "Labor" },
  { key: "MaterialCost", label: "Materials" },
  { key: "TaxAmount", label: "Tax" },
  { key: "TotalAmount", label: "Total" },
  { key: "PaymentStatus", label: "Status" },
  { key: "PaymentDate", label: "Paid Date" },
  { key: "PaymentMethod", label: "Payment Method" },
  { key: "PaymentReference", label: "Reference" },
  { key: "ApprovalDate", label: "Approved Date" },
]

const formFields = [
  { name: "InvoiceNumber", label: "Invoice Number", type: "text" as const, required: true },
  { name: "WorkOrderID", label: "Work Order", type: "select" as const, required: true, endpoint: "/api/work-orders" },
  { name: "VendorID", label: "Vendor", type: "select" as const, required: true, endpoint: "/api/vendors" },
  { name: "ApprovedByManagerID", label: "Approved By Manager", type: "select" as const, endpoint: "/api/managers" },
  { name: "InvoiceDate", label: "Invoice Date", type: "date" as const, required: true },
  { name: "DueDate", label: "Due Date", type: "date" as const, required: true },
  { name: "LaborCost", label: "Labor Cost", type: "number" as const, step: "0.01" },
  { name: "MaterialCost", label: "Material Cost", type: "number" as const, step: "0.01" },
  { name: "TaxAmount", label: "Tax Amount", type: "number" as const, step: "0.01" },
  { name: "TotalAmount", label: "Total Amount", type: "number" as const, required: true, step: "0.01" },
  {
    name: "PaymentStatus",
    label: "Payment Status",
    type: "select" as const,
    required: true,
    options: [
      { value: "Pending", label: "Pending" },
      { value: "Approved", label: "Approved" },
      { value: "Paid", label: "Paid" },
      { value: "Overdue", label: "Overdue" },
      { value: "Cancelled", label: "Cancelled" },
    ],
  },
  { name: "PaymentDate", label: "Payment Date", type: "date" as const },
  { name: "PaymentMethod", label: "Payment Method", type: "text" as const },
  { name: "PaymentReference", label: "Payment Reference", type: "text" as const },
  { name: "ApprovalDate", label: "Approval Date", type: "datetime-local" as const },
]

export default function InvoicesPage() {
  const [invoices, setInvoices] = useState<Invoice[]>([])
  const [isModalOpen, setIsModalOpen] = useState(false)
  const [selectedInvoice, setSelectedInvoice] = useState<Invoice | null>(null)
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    fetchInvoices()
  }, [])

  async function fetchInvoices() {
    try {
      const response = await fetch("/api/invoices")
      const data = await response.json()
      setInvoices(data)
    } catch (error) {
      console.error("Error fetching invoices:", error)
    }
  }

  const handleAdd = () => {
    setSelectedInvoice(null)
    setIsModalOpen(true)
  }

  const handleEdit = (invoice: Invoice) => {
    setSelectedInvoice(invoice)
    setIsModalOpen(true)
  }

  const handleDelete = async (invoice: Invoice) => {
    if (confirm(`Delete invoice ${invoice.InvoiceNumber}?`)) {
      try {
        const response = await fetch(`/api/invoices?id=${invoice.InvoiceID}`, {
          method: "DELETE",
        })

        if (response.ok) {
          await fetchInvoices()
        } else {
          const data = await response.json()
          alert(`Error: ${data.error}`)
        }
      } catch (error) {
        alert("Error deleting invoice")
      }
    }
  }

  const handleSubmit = async (data: any) => {
    setLoading(true)
    try {
      const isEdit = selectedInvoice && selectedInvoice.InvoiceID
      const method = isEdit ? "PUT" : "POST"
      const url = "/api/invoices"

      const payload: any = { ...data }
      if (isEdit) {
        payload.InvoiceID = selectedInvoice.InvoiceID
      }

      const response = await fetch(url, {
        method,
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload),
      })

      if (response.ok) {
        await fetchInvoices()
        setIsModalOpen(false)
      } else {
        const errorData = await response.json()
        alert(`Error: ${errorData.error}`)
      }
    } catch (error) {
      alert("Error saving invoice")
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold text-foreground">Invoices</h1>
        <p className="text-gray-600 mt-1">Track vendor invoices and payments</p>
      </div>

      <DataTable
        columns={columns}
        data={invoices}
        onEdit={handleEdit}
        onDelete={handleDelete}
        onAdd={handleAdd}
        title="Invoices List"
      />

      <FormModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        onSubmit={handleSubmit}
        title={selectedInvoice ? "Edit Invoice" : "Add Invoice"}
        fields={formFields}
        initialData={selectedInvoice}
        loading={loading}
      />
    </div>
  )
}
