"use client"

import { useState, useEffect } from "react"
import DataTable from "@/components/data-table"
import FormModal from "@/components/form-modal"

const columns = [
  { key: "escalation_id", label: "ID", sortable: true },
  { key: "request_id", label: "Request ID", sortable: true },
  { key: "escalation_level", label: "Level" },
  { key: "escalated_by_manager_id", label: "Manager ID" },
  { key: "escalation_reason", label: "Reason" },
  { key: "target_resolution_date", label: "Target Date" },
  { key: "resolution_notes", label: "Resolution Notes" },
  { key: "escalation_status", label: "Status" },
  { key: "escalation_date", label: "Date" },
]

const formFields = [
  { name: "request_id", label: "Request ID", type: "number" as const, required: true },
  { name: "escalation_level", label: "Escalation Level", type: "number" as const, required: true },
  { name: "escalated_by_manager_id", label: "Manager ID", type: "number" as const, required: true },
  { name: "escalation_reason", label: "Reason", type: "textarea" as const, required: true },
  { name: "target_resolution_date", label: "Target Date", type: "date" as const },
  { name: "resolution_notes", label: "Resolution Notes", type: "textarea" as const },
]

export default function EscalationsPage() {
  const [data, setData] = useState([])
  const [isModalOpen, setIsModalOpen] = useState(false)
  const [selected, setSelected] = useState(null)
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    fetchData()
  }, [])

  async function fetchData() {
    const res = await fetch("/api/escalations")
    const result = await res.json()
    setData(result)
  }

  const handleSubmit = async (formData: any) => {
    setLoading(true)
    try {
      const method = selected ? "PUT" : "POST"
      const payload = selected ? { ...formData, escalation_id: selected.escalation_id } : formData

      const res = await fetch("/api/escalations", {
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
    if (confirm("Delete this escalation?")) {
      await fetch(`/api/escalations?id=${item.escalation_id}`, { method: "DELETE" })
      await fetchData()
    }
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold">Escalations</h1>
        <p className="text-muted-foreground mt-1">Manage maintenance request escalations</p>
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
        title="Escalations"
      />

      <FormModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        onSubmit={handleSubmit}
        title={selected ? "Edit Escalation" : "Add Escalation"}
        fields={formFields}
        initialData={selected}
        loading={loading}
      />
    </div>
  )
}
