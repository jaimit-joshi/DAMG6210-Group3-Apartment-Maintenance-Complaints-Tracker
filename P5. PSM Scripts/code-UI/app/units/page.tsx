"use client"

import { useState, useEffect } from "react"
import DataTable from "@/components/data-table"
import FormModal from "@/components/form-modal"
import type { ApartmentUnit } from "@/lib/types"

const columns = [
  { key: "UnitID", label: "ID", sortable: true },
  { key: "BuildingID", label: "Building", sortable: true },
  { key: "UnitNumber", label: "Unit #", sortable: true },
  { key: "FloorNumber", label: "Floor" },
  { key: "UnitType", label: "Type" },
  { key: "SquareFootage", label: "Sq Ft" },
  { key: "NumberBedrooms", label: "Beds" },
  { key: "NumberBathrooms", label: "Baths" },
  { key: "BaseRentAmount", label: "Rent" },
  { key: "UnitStatus", label: "Status" },
]

const formFields = [
  { name: "BuildingID", label: "Building ID", type: "select" as const, required: true, endpoint: "/api/buildings" },
  { name: "UnitNumber", label: "Unit Number", type: "text" as const, required: true, maxLength: 30 },
  { name: "FloorNumber", label: "Floor Number", type: "number" as const, required: true },
  { name: "UnitType", label: "Unit Type", type: "text" as const, required: true, maxLength: 50 },
  { name: "SquareFootage", label: "Square Footage", type: "number" as const, required: true, min: 1 },
  { name: "NumberBedrooms", label: "Bedrooms", type: "number" as const, required: true, min: 0 },
  { name: "NumberBathrooms", label: "Bathrooms", type: "number" as const, required: true, step: "0.01", min: 0.01 },
  {
    name: "BaseRentAmount",
    label: "Base Rent Amount",
    type: "number" as const,
    required: true,
    step: "0.01",
    min: 0,
  },
  {
    name: "UnitStatus",
    label: "Status",
    type: "select" as const,
    required: true,
    options: [
      { value: "Available", label: "Available" },
      { value: "Occupied", label: "Occupied" },
      { value: "Maintenance", label: "Maintenance" },
      { value: "Unavailable", label: "Unavailable" },
    ],
  },
]

export default function UnitsPage() {
  const [units, setUnits] = useState<ApartmentUnit[]>([])
  const [isModalOpen, setIsModalOpen] = useState(false)
  const [selectedUnit, setSelectedUnit] = useState<ApartmentUnit | null>(null)
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    fetchUnits()
  }, [])

  async function fetchUnits() {
    try {
      const response = await fetch("/api/units")
      const data = await response.json()
      setUnits(data)
    } catch (error) {
      console.error("Error fetching units:", error)
    }
  }

  const handleAdd = () => {
    setSelectedUnit(null)
    setIsModalOpen(true)
  }

  const handleEdit = (unit: ApartmentUnit) => {
    setSelectedUnit(unit)
    setIsModalOpen(true)
  }

  const handleDelete = async (unit: ApartmentUnit) => {
    if (confirm(`Delete ${unit.UnitNumber}?`)) {
      try {
        const response = await fetch(`/api/units?id=${unit.UnitID}`, {
          method: "DELETE",
        })

        if (response.ok) {
          await fetchUnits()
        } else {
          const data = await response.json()
          alert(`Error: ${data.error}`)
        }
      } catch (error) {
        alert("Error deleting unit")
      }
    }
  }

  const handleSubmit = async (data: any) => {
    setLoading(true)
    try {
      const isEdit = selectedUnit && selectedUnit.UnitID
      const method = isEdit ? "PUT" : "POST"
      const url = "/api/units"

      const payload: any = { ...data }
      if (isEdit) {
        payload.UnitID = selectedUnit.UnitID
      }

      const response = await fetch(url, {
        method,
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload),
      })

      if (response.ok) {
        await fetchUnits()
        setIsModalOpen(false)
      } else {
        const errorData = await response.json()
        alert(`Error: ${errorData.error}`)
      }
    } catch (error) {
      alert("Error saving unit")
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold text-foreground">Apartments/Units</h1>
        <p className="text-gray-600 mt-1">Manage rental units and apartments</p>
      </div>

      <DataTable
        columns={columns}
        data={units}
        onEdit={handleEdit}
        onDelete={handleDelete}
        onAdd={handleAdd}
        title="Units List"
      />

      <FormModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        onSubmit={handleSubmit}
        title={selectedUnit ? "Edit Unit" : "Add Unit"}
        fields={formFields}
        initialData={selectedUnit}
        loading={loading}
      />
    </div>
  )
}
