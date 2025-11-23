"use client"

import { useState, useEffect } from "react"
import DataTable from "@/components/data-table"
import FormModal from "@/components/form-modal"

const columns = [
  { key: "occupant_id", label: "ID", sortable: true },
  { key: "lease_id", label: "Lease ID", sortable: true },
  { key: "resident_id", label: "Resident ID", sortable: true },
  { key: "occupant_type", label: "Type" },
  { key: "move_in_date", label: "Move In Date" },
  { key: "move_out_date", label: "Move Out Date" },
]

const formFields = [
  { name: "lease_id", label: "Lease ID", type: "number" as const, required: true },
  { name: "resident_id", label: "Resident ID", type: "number" as const, required: true },
  { name: "occupant_type", label: "Occupant Type", type: "text" as const, required: true },
  { name: "move_in_date", label: "Move In Date", type: "date" as const, required: true },
  { name: "move_out_date", label: "Move Out Date", type: "date" as const },
]

export default function LeaseOccupantsPage() {
  const [data, setData] = useState([])
  const [isModalOpen, setIsModalOpen] = useState(false)
  const [selected, setSelected] = useState(null)
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    fetchData()
  }, [])

  async function fetchData() {
    const res = await fetch("/api/lease-occupants")
    const result = await res.json()
    setData(result)
  }

  const handleSubmit = async (formData: any) => {
    setLoading(true)
    try {
      const method = selected ? "PUT" : "POST"
      const payload = selected ? { ...formData, occupant_id: selected.occupant_id } : formData

      const res = await fetch("/api/lease-occupants", {
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
    if (confirm("Delete this lease occupant?")) {
      await fetch(`/api/lease-occupants?id=${item.occupant_id}`, { method: "DELETE" })
      await fetchData()
    }
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold">Lease Occupants</h1>
        <p className="text-muted-foreground mt-1">Manage lease occupant records</p>
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
        title="Lease Occupants"
      />

      <FormModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        onSubmit={handleSubmit}
        title={selected ? "Edit Lease Occupant" : "Add Lease Occupant"}
        fields={formFields}
        initialData={selected}
        loading={loading}
      />
    </div>
  )
}
