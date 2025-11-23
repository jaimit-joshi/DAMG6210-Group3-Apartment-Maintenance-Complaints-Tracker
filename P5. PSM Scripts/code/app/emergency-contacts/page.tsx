"use client"

import { useState, useEffect } from "react"
import DataTable from "@/components/data-table"
import FormModal from "@/components/form-modal"

const columns = [
  { key: "contact_id", label: "ID", sortable: true },
  { key: "resident_id", label: "Resident ID", sortable: true },
  { key: "contact_name", label: "Name", sortable: true },
  { key: "relationship", label: "Relationship" },
  { key: "phone_number", label: "Phone" },
  { key: "alternate_phone", label: "Alt Phone" },
  { key: "email_address", label: "Email" },
  { key: "is_primary", label: "Primary" },
]

const formFields = [
  { name: "resident_id", label: "Resident ID", type: "number" as const, required: true },
  { name: "contact_name", label: "Contact Name", type: "text" as const, required: true },
  { name: "relationship", label: "Relationship", type: "text" as const, required: true },
  { name: "phone_number", label: "Phone Number", type: "text" as const, required: true },
  { name: "alternate_phone", label: "Alternate Phone", type: "text" as const },
  { name: "email_address", label: "Email", type: "email" as const },
  { name: "is_primary", label: "Is Primary", type: "checkbox" as const },
]

export default function EmergencyContactsPage() {
  const [data, setData] = useState([])
  const [isModalOpen, setIsModalOpen] = useState(false)
  const [selected, setSelected] = useState(null)
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    fetchData()
  }, [])

  async function fetchData() {
    const res = await fetch("/api/emergency-contacts")
    const result = await res.json()
    setData(result)
  }

  const handleSubmit = async (formData: any) => {
    setLoading(true)
    try {
      const method = selected ? "PUT" : "POST"
      const payload = selected ? { ...formData, contact_id: selected.contact_id } : formData

      const res = await fetch("/api/emergency-contacts", {
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
    if (confirm("Delete this emergency contact?")) {
      await fetch(`/api/emergency-contacts?id=${item.contact_id}`, { method: "DELETE" })
      await fetchData()
    }
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold">Emergency Contacts</h1>
        <p className="text-muted-foreground mt-1">Manage resident emergency contacts</p>
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
        title="Emergency Contacts"
      />

      <FormModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        onSubmit={handleSubmit}
        title={selected ? "Edit Emergency Contact" : "Add Emergency Contact"}
        fields={formFields}
        initialData={selected}
        loading={loading}
      />
    </div>
  )
}
