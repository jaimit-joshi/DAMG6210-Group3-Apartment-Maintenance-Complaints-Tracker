"use client"

import { useState, useEffect } from "react"
import DataTable from "@/components/data-table"
import FormModal from "@/components/form-modal"

const columns = [
  { key: "worker_id", label: "ID", sortable: true },
  { key: "vendor_id", label: "Vendor ID", sortable: true },
  { key: "first_name", label: "First Name", sortable: true },
  { key: "last_name", label: "Last Name", sortable: true },
  { key: "employee_id", label: "Employee ID" },
  { key: "worker_type", label: "Type" },
  { key: "phone_number", label: "Phone" },
  { key: "email_address", label: "Email" },
  { key: "hourly_rate", label: "Hourly Rate" },
  { key: "specialization", label: "Specialization" },
  { key: "worker_status", label: "Status" },
]

const formFields = [
  { name: "vendor_id", label: "Vendor ID", type: "number" as const, required: true },
  { name: "first_name", label: "First Name", type: "text" as const, required: true },
  { name: "last_name", label: "Last Name", type: "text" as const, required: true },
  { name: "employee_id", label: "Employee ID", type: "text" as const },
  { name: "worker_type", label: "Worker Type", type: "text" as const, required: true },
  { name: "phone_number", label: "Phone Number", type: "text" as const, required: true },
  { name: "email_address", label: "Email", type: "email" as const },
  { name: "hourly_rate", label: "Hourly Rate", type: "number" as const },
  { name: "specialization", label: "Specialization", type: "text" as const },
]

export default function WorkersPage() {
  const [data, setData] = useState([])
  const [isModalOpen, setIsModalOpen] = useState(false)
  const [selected, setSelected] = useState(null)
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    fetchData()
  }, [])

  async function fetchData() {
    const res = await fetch("/api/workers")
    const result = await res.json()
    setData(result)
  }

  const handleSubmit = async (formData: any) => {
    setLoading(true)
    try {
      const method = selected ? "PUT" : "POST"
      const payload = selected ? { ...formData, worker_id: selected.worker_id } : formData

      const res = await fetch("/api/workers", {
        method,
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload),
      })

      if (res.ok) {
        await fetchData()
        setIsModalOpen(false)
        setSelected(null)
      }
    } catch (error) {
      console.error("Error:", error)
    } finally {
      setLoading(false)
    }
  }

  const handleDelete = async (item: any) => {
    if (confirm("Delete this worker?")) {
      await fetch(`/api/workers?id=${item.worker_id}`, { method: "DELETE" })
      await fetchData()
    }
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold">Workers</h1>
        <p className="text-muted-foreground mt-1">Manage vendor workers</p>
      </div>

      <DataTable
        columns={columns}
        data={data}
        onEdit={(item) => {
          setSelected(item)
          setIsModalOpen(true)
        }}
        onDelete={handleDelete}
        onAdd={() => {
          setSelected(null)
          setIsModalOpen(true)
        }}
        title="Workers"
      />

      <FormModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        onSubmit={handleSubmit}
        title={selected ? "Edit Worker" : "Add Worker"}
        fields={formFields}
        initialData={selected}
        loading={loading}
      />
    </div>
  )
}
