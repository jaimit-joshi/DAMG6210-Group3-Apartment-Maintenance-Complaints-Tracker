"use client"

import { useState, useEffect } from "react"
import DataTable from "@/components/data-table"
import FormModal from "@/components/form-modal"

const columns = [
  { key: "assignment_id", label: "ID", sortable: true },
  { key: "building_id", label: "Building ID", sortable: true },
  { key: "manager_id", label: "Manager ID", sortable: true },
  { key: "assignment_start_date", label: "Start Date" },
  { key: "assignment_end_date", label: "End Date" },
  { key: "is_primary", label: "Primary" },
]

const formFields = [
  { name: "building_id", label: "Building ID", type: "number" as const, required: true },
  { name: "manager_id", label: "Manager ID", type: "number" as const, required: true },
  { name: "assignment_start_date", label: "Start Date", type: "date" as const, required: true },
  { name: "assignment_end_date", label: "End Date", type: "date" as const },
  { name: "is_primary", label: "Is Primary", type: "checkbox" as const },
]

export default function ManagerAssignmentsPage() {
  const [data, setData] = useState([])
  const [isModalOpen, setIsModalOpen] = useState(false)
  const [selected, setSelected] = useState(null)
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    fetchData()
  }, [])

  async function fetchData() {
    const res = await fetch("/api/manager-assignments")
    const result = await res.json()
    setData(result)
  }

  const handleSubmit = async (formData: any) => {
    setLoading(true)
    try {
      const method = selected ? "PUT" : "POST"
      const payload = selected ? { ...formData, assignment_id: selected.assignment_id } : formData

      const res = await fetch("/api/manager-assignments", {
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
    if (confirm("Delete this manager assignment?")) {
      await fetch(`/api/manager-assignments?id=${item.assignment_id}`, { method: "DELETE" })
      await fetchData()
    }
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold">Manager Assignments</h1>
        <p className="text-muted-foreground mt-1">Manage building manager assignments</p>
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
        title="Manager Assignments"
      />

      <FormModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        onSubmit={handleSubmit}
        title={selected ? "Edit Assignment" : "Add Assignment"}
        fields={formFields}
        initialData={selected}
        loading={loading}
      />
    </div>
  )
}
