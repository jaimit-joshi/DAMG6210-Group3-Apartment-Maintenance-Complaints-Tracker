"use client"

import { useState, useEffect } from "react"
import DataTable from "@/components/data-table"
import FormModal from "@/components/form-modal"
import type { Building } from "@/lib/types"

const columns = [
  { key: "BuildingID", label: "ID", sortable: true },
  { key: "BuildingName", label: "Name", sortable: true },
  { key: "StreetAddress", label: "Street" },
  { key: "City", label: "City", sortable: true },
  { key: "State", label: "State" },
  { key: "ZipCode", label: "ZIP" },
  { key: "YearBuilt", label: "Year Built" },
  { key: "NumberOfFloors", label: "Floors" },
  { key: "TotalUnits", label: "Units" },
  { key: "BuildingType", label: "Type" },
  { key: "HasElevator", label: "Elevator" },
]

const formFields = [
  { name: "BuildingName", label: "Building Name", type: "text" as const, required: true, maxLength: 150 },
  { name: "StreetAddress", label: "Street Address", type: "text" as const, required: true, maxLength: 100 },
  { name: "City", label: "City", type: "text" as const, required: true, maxLength: 30 },
  { name: "State", label: "State", type: "text" as const, required: true, maxLength: 20 },
  { name: "ZipCode", label: "ZIP Code", type: "text" as const, required: true, maxLength: 10 },
  {
    name: "YearBuilt",
    label: "Year Built",
    type: "number" as const,
    required: true,
    min: 1900,
    max: new Date().getFullYear(),
  },
  { name: "NumberOfFloors", label: "Number of Floors", type: "number" as const, required: true, min: 1 },
  { name: "TotalUnits", label: "Total Units", type: "number" as const, required: true, min: 1 },
  { name: "BuildingType", label: "Building Type", type: "text" as const, required: true, maxLength: 50 },
  { name: "HasElevator", label: "Has Elevator", type: "checkbox" as const },
]

export default function BuildingsPage() {
  const [buildings, setBuildings] = useState<Building[]>([])
  const [isModalOpen, setIsModalOpen] = useState(false)
  const [selectedBuilding, setSelectedBuilding] = useState<Building | null>(null)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    fetchBuildings()
  }, [])

  async function fetchBuildings() {
    try {
      setError(null)
      const response = await fetch("/api/buildings")
      const data = await response.json()

      if (response.ok && Array.isArray(data)) {
        setBuildings(data)
      } else if (data.error) {
        setError(data.error)
        setBuildings([])
      } else {
        setError("Unexpected response format")
        setBuildings([])
      }
    } catch (error) {
      console.error("Error fetching buildings:", error)
      setError("Failed to fetch buildings")
      setBuildings([])
    }
  }

  const handleAdd = () => {
    setSelectedBuilding(null)
    setIsModalOpen(true)
  }

  const handleEdit = (building: Building) => {
    setSelectedBuilding(building)
    setIsModalOpen(true)
  }

  const handleDelete = async (building: Building) => {
    if (confirm(`Delete "${building.BuildingName}"? This action cannot be undone.`)) {
      try {
        const response = await fetch(`/api/buildings?id=${building.BuildingID}`, {
          method: "DELETE",
        })

        if (response.ok) {
          await fetchBuildings()
          setError(null)
        } else {
          const data = await response.json()
          setError(data.error || "Failed to delete building")
        }
      } catch (error) {
        console.error("Error deleting building:", error)
        setError("Failed to delete building")
      }
    }
  }

  const handleSubmit = async (data: any) => {
    setLoading(true)
    try {
      const isEdit = selectedBuilding && selectedBuilding.BuildingID
      const method = isEdit ? "PUT" : "POST"
      const url = "/api/buildings"

      const payload: any = { ...data }

      if (!isEdit) {
        payload.BuildingID = Date.now().toString() // Auto-generate BuildingID if it's a new building
      }

      const response = await fetch(url, {
        method,
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload),
      })

      if (response.ok) {
        await fetchBuildings()
        setIsModalOpen(false)
        setError(null)
      } else {
        const errorData = await response.json()
        setError(errorData.error || `Failed to ${isEdit ? "update" : "create"} building`)
      }
    } catch (error) {
      console.error("Error saving building:", error)
      setError("Failed to save building")
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold text-foreground">Buildings</h1>
        <p className="text-gray-600 mt-1">Manage all properties</p>
      </div>

      {error && (
        <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg">
          <p>
            <strong>Error:</strong> {error}
          </p>
        </div>
      )}

      <DataTable
        columns={columns}
        data={buildings}
        onEdit={handleEdit}
        onDelete={handleDelete}
        onAdd={handleAdd}
        title="Buildings List"
      />

      <FormModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        onSubmit={handleSubmit}
        title={selectedBuilding ? "Edit Building" : "Add Building"}
        fields={formFields}
        initialData={selectedBuilding}
        loading={loading}
      />
    </div>
  )
}
