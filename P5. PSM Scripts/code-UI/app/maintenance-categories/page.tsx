"use client"

import { useState, useEffect } from "react"
import DataTable from "@/components/data-table"
import FormModal from "@/components/form-modal"

const columns = [
  { key: "category_id", label: "ID", sortable: true },
  { key: "category_code", label: "Code", sortable: true },
  { key: "category_name", label: "Name", sortable: true },
  { key: "category_description", label: "Description" },
  { key: "default_priority", label: "Priority" },
  { key: "target_response_hours", label: "Response Hours" },
  { key: "target_resolution_hours", label: "Resolution Hours" },
  { key: "requires_work_order", label: "Requires WO" },
  { key: "is_active", label: "Active" },
]

const formFields = [
  { name: "category_code", label: "Category Code", type: "text" as const, required: true },
  { name: "category_name", label: "Category Name", type: "text" as const, required: true },
  { name: "category_description", label: "Description", type: "textarea" as const },
  { name: "default_priority", label: "Default Priority", type: "text" as const, required: true },
  { name: "target_response_hours", label: "Response Hours", type: "number" as const, required: true },
  { name: "target_resolution_hours", label: "Resolution Hours", type: "number" as const, required: true },
  { name: "requires_work_order", label: "Requires Work Order", type: "checkbox" as const },
  { name: "is_active", label: "Is Active", type: "checkbox" as const },
]

export default function MaintenanceCategoriesPage() {
  const [data, setData] = useState([])
  const [isModalOpen, setIsModalOpen] = useState(false)
  const [selected, setSelected] = useState(null)
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    fetchData()
  }, [])

  async function fetchData() {
    const res = await fetch("/api/maintenance-categories")
    const result = await res.json()
    setData(result)
  }

  const handleSubmit = async (formData: any) => {
    setLoading(true)
    try {
      const method = selected ? "PUT" : "POST"
      const payload = selected ? { ...formData, category_id: selected.category_id } : formData

      const res = await fetch("/api/maintenance-categories", {
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
    if (confirm("Delete this maintenance category?")) {
      await fetch(`/api/maintenance-categories?id=${item.category_id}`, { method: "DELETE" })
      await fetchData()
    }
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold">Maintenance Categories</h1>
        <p className="text-muted-foreground mt-1">Manage maintenance request categories</p>
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
        title="Maintenance Categories"
      />

      <FormModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        onSubmit={handleSubmit}
        title={selected ? "Edit Category" : "Add Category"}
        fields={formFields}
        initialData={selected}
        loading={loading}
      />
    </div>
  )
}
