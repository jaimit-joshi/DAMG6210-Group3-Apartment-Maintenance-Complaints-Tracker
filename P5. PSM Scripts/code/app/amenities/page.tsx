"use client"

import { useState, useEffect } from "react"
import DataTable from "@/components/data-table"
import FormModal from "@/components/form-modal"

const columns = [
  { key: "amenity_id", label: "ID", sortable: true },
  { key: "amenity_code", label: "Code", sortable: true },
  { key: "amenity_name", label: "Name", sortable: true },
  { key: "amenity_type", label: "Type" },
  { key: "description", label: "Description" },
  { key: "is_active", label: "Active" },
]

const formFields = [
  { name: "amenity_code", label: "Amenity Code", type: "text" as const, required: true },
  { name: "amenity_name", label: "Amenity Name", type: "text" as const, required: true },
  { name: "amenity_type", label: "Type", type: "text" as const, required: true },
  { name: "description", label: "Description", type: "textarea" as const },
  { name: "is_active", label: "Is Active", type: "checkbox" as const },
]

export default function AmenitiesPage() {
  const [data, setData] = useState([])
  const [isModalOpen, setIsModalOpen] = useState(false)
  const [selected, setSelected] = useState(null)
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    fetchData()
  }, [])

  async function fetchData() {
    const res = await fetch("/api/amenities")
    const result = await res.json()
    setData(result)
  }

  const handleSubmit = async (formData: any) => {
    setLoading(true)
    try {
      const method = selected ? "PUT" : "POST"
      const payload = selected ? { ...formData, amenity_id: selected.amenity_id } : formData

      const res = await fetch("/api/amenities", {
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
    if (confirm("Delete this amenity?")) {
      await fetch(`/api/amenities?id=${item.amenity_id}`, { method: "DELETE" })
      await fetchData()
    }
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold">Amenities</h1>
        <p className="text-muted-foreground mt-1">Manage property amenities</p>
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
        title="Amenities"
      />

      <FormModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        onSubmit={handleSubmit}
        title={selected ? "Edit Amenity" : "Add Amenity"}
        fields={formFields}
        initialData={selected}
        loading={loading}
      />
    </div>
  )
}
