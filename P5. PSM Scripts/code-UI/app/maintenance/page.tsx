"use client"

import { useState, useEffect } from "react"
import DataTable from "@/components/data-table"
import FormModal from "@/components/form-modal"
import type { MaintenanceRequest } from "@/lib/types"

const columns = [
  { key: "RequestID", label: "ID", sortable: true },
  { key: "UnitID", label: "Unit", sortable: true },
  { key: "RequestTitle", label: "Title", sortable: true },
  { key: "RequestPriority", label: "Priority" },
  { key: "RequestStatus", label: "Status" },
  { key: "SubmittedDate", label: "Submitted" },
]

const formFields = [
  { name: "ResidentID", label: "Resident", type: "select" as const, required: true, endpoint: "/api/residents" },
  { name: "UnitID", label: "Unit", type: "select" as const, required: true, endpoint: "/api/units" },
  {
    name: "CategoryID",
    label: "Category",
    type: "select" as const,
    required: true,
    endpoint: "/api/maintenance-categories",
  },
  { name: "RequestTitle", label: "Request Title (max 75 chars)", type: "text" as const, required: true, maxLength: 75 },
  {
    name: "RequestDescription",
    label: "Description (max 500 chars)",
    type: "textarea" as const,
    required: true,
    maxLength: 500,
  },
  {
    name: "RequestPriority",
    label: "Priority",
    type: "select" as const,
    required: true,
    options: [
      { value: "Low", label: "Low" },
      { value: "Normal", label: "Normal" },
      { value: "High", label: "High" },
      { value: "Urgent", label: "Urgent" },
    ],
  },
  {
    name: "RequestStatus",
    label: "Status",
    type: "select" as const,
    required: true,
    options: [
      { value: "Submitted", label: "Submitted" },
      { value: "Acknowledged", label: "Acknowledged" },
      { value: "In Progress", label: "In Progress" },
      { value: "Completed", label: "Completed" },
      { value: "Closed", label: "Closed" },
    ],
  },
  { name: "AcknowledgedDate", label: "Acknowledged Date", type: "datetime-local" as const },
  { name: "CompletedDate", label: "Completed Date", type: "datetime-local" as const },
  { name: "PermissionToEnter", label: "Permission to Enter", type: "checkbox" as const },
  { name: "PetOnPremises", label: "Pet on Premises", type: "checkbox" as const },
]

export default function MaintenancePage() {
  const [requests, setRequests] = useState<MaintenanceRequest[]>([])
  const [isModalOpen, setIsModalOpen] = useState(false)
  const [selectedRequest, setSelectedRequest] = useState<MaintenanceRequest | null>(null)
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    fetchRequests()
  }, [])

  async function fetchRequests() {
    try {
      const response = await fetch("/api/maintenance")
      const data = await response.json()
      setRequests(data)
    } catch (error) {
      console.error("Error fetching maintenance requests:", error)
    }
  }

  const handleAdd = () => {
    setSelectedRequest(null)
    setIsModalOpen(true)
  }

  const handleEdit = (request: MaintenanceRequest) => {
    setSelectedRequest(request)
    setIsModalOpen(true)
  }

  const handleDelete = async (request: MaintenanceRequest) => {
    if (confirm(`Delete maintenance request ${request.RequestID}?`)) {
      try {
        const response = await fetch(`/api/maintenance?id=${request.RequestID}`, {
          method: "DELETE",
        })

        if (response.ok) {
          await fetchRequests()
        } else {
          const data = await response.json()
          alert(`Error: ${data.error}`)
        }
      } catch (error) {
        alert("Error deleting maintenance request")
      }
    }
  }

  const handleSubmit = async (data: any) => {
    setLoading(true)
    try {
      const isEdit = selectedRequest && selectedRequest.RequestID
      const method = isEdit ? "PUT" : "POST"
      const url = "/api/maintenance"

      const payload: any = { ...data }
      if (isEdit) {
        payload.RequestID = selectedRequest.RequestID
      }

      const response = await fetch(url, {
        method,
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload),
      })

      if (response.ok) {
        await fetchRequests()
        setIsModalOpen(false)
      } else {
        const errorData = await response.json()
        alert(`Error: ${errorData.error}`)
      }
    } catch (error) {
      alert("Error saving maintenance request")
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold text-foreground">Maintenance Requests</h1>
        <p className="text-gray-600 mt-1">Track and manage maintenance issues</p>
      </div>

      <DataTable
        columns={columns}
        data={requests}
        onEdit={handleEdit}
        onDelete={handleDelete}
        onAdd={handleAdd}
        title="Maintenance Requests"
      />

      <FormModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        onSubmit={handleSubmit}
        title={selectedRequest ? "Edit Request" : "Add Request"}
        fields={formFields}
        initialData={selectedRequest}
        loading={loading}
      />
    </div>
  )
}
