"use client"

import { useState, useEffect } from "react"
import DataTable from "@/components/data-table"
import FormModal from "@/components/form-modal"

const columns = [
  { key: "building_amenity_id", label: "ID", sortable: true },
  { key: "building_id", label: "Building ID", sortable: true },
  { key: "amenity_id", label: "Amenity ID", sortable: true },
  { key: "amenity_location", label: "Location" },
  { key: "access_restrictions", label: "Access" },
  { key: "additional_fee", label: "Fee" },
]

const formFields = [
  { name: "building_id", label: "Building ID", type: "number" as const, required: true },
  { name: "amenity_id", label: "Amenity ID", type: "number" as const, required: true },
  { name: "amenity_location", label: "Location", type: "text" as const },
  { name: "access_restrictions", label: "Access Restrictions", type: "text" as const },
  { name: "additional_fee", label: "Additional Fee", type: "number" as const },
]

export default function BuildingAmenitiesPage() {
  const [data, setData] = useState([])
  const [isModalOpen, setIsModalOpen] = useState(false)
  const [selected, setSelected] = useState(null)
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    fetchData()
  }, [])

  async function fetchData() {
    const res = await fetch("/api/building-amenities")
    const result = await res.json()
    setData(result)
  }

  const handleSubmit = async (formData: any) => {
    setLoading(true)
    try {
      const method = selected ? "PUT" : "POST"
      const payload = selected ? { ...formData, building_amenity_id: selected.building_amenity_id } : formData

      const res = await fetch("/api/building-amenities", {
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
    if (confirm("Delete this building amenity?")) {
      await fetch(`/api/building-amenities?id=${item.building_amenity_id}`, { method: "DELETE" })
      await fetchData()
    }
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold">Building Amenities</h1>
        <p className="text-muted-foreground mt-1">Manage amenities for buildings</p>
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
        title="Building Amenities"
      />

      <FormModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        onSubmit={handleSubmit}
        title={selected ? "Edit Building Amenity" : "Add Building Amenity"}
        fields={formFields}
        initialData={selected}
        loading={loading}
      />
    </div>
  )
}
