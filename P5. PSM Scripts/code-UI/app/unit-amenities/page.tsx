"use client"

import { useState, useEffect } from "react"
import DataTable from "@/components/data-table"
import FormModal from "@/components/form-modal"

const columns = [
  { key: "unit_amenity_id", label: "ID", sortable: true },
  { key: "unit_id", label: "Unit ID", sortable: true },
  { key: "amenity_id", label: "Amenity ID", sortable: true },
  { key: "installation_date", label: "Installed" },
  { key: "condition", label: "Condition" },
  { key: "last_service_date", label: "Last Service" },
]

const formFields = [
  { name: "unit_id", label: "Unit ID", type: "number" as const, required: true },
  { name: "amenity_id", label: "Amenity ID", type: "number" as const, required: true },
  { name: "installation_date", label: "Installation Date", type: "date" as const },
  { name: "condition", label: "Condition", type: "text" as const },
  { name: "last_service_date", label: "Last Service Date", type: "date" as const },
]

export default function UnitAmenitiesPage() {
  const [data, setData] = useState([])
  const [isModalOpen, setIsModalOpen] = useState(false)
  const [selected, setSelected] = useState(null)
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    fetchData()
  }, [])

  async function fetchData() {
    const res = await fetch("/api/unit-amenities")
    const result = await res.json()
    setData(result)
  }

  const handleSubmit = async (formData: any) => {
    setLoading(true)
    try {
      const method = selected ? "PUT" : "POST"
      const payload = selected ? { ...formData, unit_amenity_id: selected.unit_amenity_id } : formData

      const res = await fetch("/api/unit-amenities", {
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
    if (confirm("Delete this unit amenity?")) {
      await fetch(`/api/unit-amenities?id=${item.unit_amenity_id}`, { method: "DELETE" })
      await fetchData()
    }
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold">Unit Amenities</h1>
        <p className="text-muted-foreground mt-1">Manage amenities for units</p>
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
        title="Unit Amenities"
      />

      <FormModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        onSubmit={handleSubmit}
        title={selected ? "Edit Unit Amenity" : "Add Unit Amenity"}
        fields={formFields}
        initialData={selected}
        loading={loading}
      />
    </div>
  )
}
