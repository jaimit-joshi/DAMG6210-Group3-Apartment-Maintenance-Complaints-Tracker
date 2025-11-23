"use client"

import { useState, useEffect } from "react"
import DataTable from "@/components/data-table"
import FormModal from "@/components/form-modal"

const columns = [
  { key: "notification_id", label: "ID", sortable: true },
  { key: "resident_id", label: "Resident ID", sortable: true },
  { key: "request_id", label: "Request ID" },
  { key: "notification_type", label: "Type" },
  { key: "subject", label: "Subject" },
  { key: "message_body", label: "Message" },
  { key: "priority", label: "Priority" },
  { key: "delivery_channel", label: "Channel" },
  { key: "delivery_status", label: "Status" },
]

const formFields = [
  { name: "resident_id", label: "Resident ID", type: "number" as const, required: true },
  { name: "request_id", label: "Request ID", type: "number" as const },
  { name: "notification_type", label: "Type", type: "text" as const, required: true },
  { name: "subject", label: "Subject", type: "text" as const, required: true },
  { name: "message_body", label: "Message", type: "textarea" as const, required: true },
  { name: "priority", label: "Priority", type: "text" as const },
  { name: "delivery_channel", label: "Channel", type: "text" as const, required: true },
]

export default function NotificationsPage() {
  const [data, setData] = useState([])
  const [isModalOpen, setIsModalOpen] = useState(false)
  const [selected, setSelected] = useState(null)
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    fetchData()
  }, [])

  async function fetchData() {
    const res = await fetch("/api/notifications")
    const result = await res.json()
    setData(result)
  }

  const handleSubmit = async (formData: any) => {
    setLoading(true)
    try {
      const method = selected ? "PUT" : "POST"
      const payload = selected ? { ...formData, notification_id: selected.notification_id } : formData

      const res = await fetch("/api/notifications", {
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
    if (confirm("Delete this notification?")) {
      await fetch(`/api/notifications?id=${item.notification_id}`, { method: "DELETE" })
      await fetchData()
    }
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold">Notifications</h1>
        <p className="text-muted-foreground mt-1">Manage resident notifications</p>
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
        title="Notifications"
      />

      <FormModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        onSubmit={handleSubmit}
        title={selected ? "Edit Notification" : "Add Notification"}
        fields={formFields}
        initialData={selected}
        loading={loading}
      />
    </div>
  )
}
