"use client"

import { useState, useEffect } from "react"
import DataTable from "@/components/data-table"
import FormModal from "@/components/form-modal"

const columns = [
  { key: "assignment_id", label: "ID", sortable: true },
  { key: "work_order_id", label: "Work Order ID", sortable: true },
  { key: "worker_id", label: "Worker ID", sortable: true },
  { key: "worker_role", label: "Role" },
  { key: "hours_worked", label: "Hours" },
  { key: "start_time", label: "Start Time" },
  { key: "end_time", label: "End Time" },
  { key: "assigned_date", label: "Assigned Date" },
]

const formFields = [
  { name: "work_order_id", label: "Work Order ID", type: "number" as const, required: true },
  { name: "worker_id", label: "Worker ID", type: "number" as const, required: true },
  { name: "worker_role", label: "Worker Role", type: "text" as const, required: true },
  { name: "hours_worked", label: "Hours Worked", type: "number" as const },
  { name: "start_time", label: "Start Time", type: "datetime-local" as const },
  { name: "end_time", label: "End Time", type: "datetime-local" as const },
]

export default function WorkerAssignmentsPage() {
  const [data, setData] = useState([])
  const [isModalOpen, setIsModalOpen] = useState(false)
  const [selected, setSelected] = useState(null)
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    fetchData()
  }, [])

  async function fetchData() {
    const res = await fetch("/api/worker-assignments")
    const result = await res.json()
    setData(result)
  }

  const handleSubmit = async (formData: any) => {
    setLoading(true)
    try {
      const method = selected ? "PUT" : "POST"
      const payload = selected ? { ...formData, assignment_id: selected.assignment_id } : formData

      const res = await fetch("/api/worker-assignments", {
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
    if (confirm("Delete this worker assignment?")) {
      await fetch(`/api/worker-assignments?id=${item.assignment_id}`, { method: "DELETE" })
      await fetchData()
    }
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold">Worker Assignments</h1>
        <p className="text-muted-foreground mt-1">Manage worker assignments to work orders</p>
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
        title="Worker Assignments"
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
