"use client"

import { useState, useEffect } from "react"
import DataTable from "@/components/data-table"
import FormModal from "@/components/form-modal"
import type { Resident } from "@/lib/types"

const columns = [
  { key: "ResidentID", label: "ID", sortable: true },
  { key: "FirstName", label: "First Name", sortable: true },
  { key: "LastName", label: "Last Name", sortable: true },
  { key: "DateOfBirth", label: "DOB" },
  { key: "SSNLast4", label: "SSN Last 4" },
  { key: "PrimaryPhone", label: "Phone" },
  { key: "AlternatePhone", label: "Alt Phone" },
  { key: "EmailAddress", label: "Email" },
  { key: "CurrentAddress", label: "Address" },
  { key: "AccountStatus", label: "Status" },
  { key: "BackgroundCheckStatus", label: "BG Check" },
  { key: "BackgroundCheckDate", label: "BG Date" },
  { key: "CreditScore", label: "Credit" },
]

const formFields = [
  { name: "FirstName", label: "First Name", type: "text" as const, required: true, maxLength: 150 },
  { name: "LastName", label: "Last Name", type: "text" as const, required: true, maxLength: 150 },
  { name: "DateOfBirth", label: "Date of Birth", type: "date" as const, required: true },
  { name: "SSNLast4", label: "SSN Last 4", type: "text" as const, maxLength: 4 },
  { name: "PrimaryPhone", label: "Primary Phone (10 digits)", type: "text" as const, required: true, maxLength: 10 },
  { name: "AlternatePhone", label: "Alternate Phone (10 digits)", type: "text" as const, maxLength: 10 },
  { name: "EmailAddress", label: "Email Address", type: "email" as const, required: true, maxLength: 100 },
  { name: "CurrentAddress", label: "Current Address", type: "text" as const, maxLength: 300 },
  {
    name: "AccountStatus",
    label: "Account Status",
    type: "select" as const,
    required: true,
    options: [
      { value: "Active", label: "Active" },
      { value: "Inactive", label: "Inactive" },
      { value: "Suspended", label: "Suspended" },
    ],
  },
  {
    name: "BackgroundCheckStatus",
    label: "Background Check Status",
    type: "select" as const,
    options: [
      { value: "Pending", label: "Pending" },
      { value: "Approved", label: "Approved" },
      { value: "Rejected", label: "Rejected" },
    ],
  },
  { name: "BackgroundCheckDate", label: "Background Check Date", type: "date" as const },
  { name: "CreditScore", label: "Credit Score (300-850)", type: "number" as const, min: 300, max: 850 },
]

export default function ResidentsPage() {
  const [residents, setResidents] = useState<Resident[]>([])
  const [isModalOpen, setIsModalOpen] = useState(false)
  const [selectedResident, setSelectedResident] = useState<Resident | null>(null)
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    fetchResidents()
  }, [])

  async function fetchResidents() {
    try {
      const response = await fetch("/api/residents")
      const data = await response.json()
      setResidents(data)
    } catch (error) {
      console.error("Error fetching residents:", error)
    }
  }

  const handleAdd = () => {
    setSelectedResident(null)
    setIsModalOpen(true)
  }

  const handleEdit = (resident: Resident) => {
    setSelectedResident(resident)
    setIsModalOpen(true)
  }

  const handleDelete = async (resident: Resident) => {
    if (confirm(`Delete ${resident.FirstName} ${resident.LastName}?`)) {
      try {
        const response = await fetch(`/api/residents?id=${resident.ResidentID}`, {
          method: "DELETE",
        })

        if (response.ok) {
          await fetchResidents()
          alert("Resident deleted successfully")
        } else {
          const data = await response.json()
          if (data.code === "ACTIVE_LEASE_EXISTS") {
            alert("Cannot delete resident: They have an active lease. Please terminate the lease first.")
          } else {
            alert(`Error: ${data.error || "Failed to delete resident"}`)
          }
          console.error("Delete error:", data.error)
        }
      } catch (error) {
        console.error("Error deleting resident:", error)
        alert("Failed to delete resident. Please try again.")
      }
    }
  }

  const handleSubmit = async (data: any) => {
    setLoading(true)
    try {
      const isEdit = selectedResident && selectedResident.ResidentID
      const method = isEdit ? "PUT" : "POST"
      const url = "/api/residents"

      const payload: any = { ...data }
      if (isEdit) {
        payload.ResidentID = selectedResident.ResidentID
      }

      const response = await fetch(url, {
        method,
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload),
      })

      if (response.ok) {
        await fetchResidents()
        setIsModalOpen(false)
        setSelectedResident(null)
      } else {
        const errorData = await response.json()
        console.error("Save error:", errorData)
      }
    } catch (error) {
      console.error("Error:", error)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold text-foreground">Residents</h1>
        <p className="text-gray-600 mt-1">Manage tenant information</p>
      </div>

      <DataTable
        columns={columns}
        data={residents}
        onEdit={handleEdit}
        onDelete={handleDelete}
        onAdd={handleAdd}
        title="Residents List"
      />

      <FormModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        onSubmit={handleSubmit}
        title={selectedResident ? "Edit Resident" : "Add Resident"}
        fields={formFields}
        initialData={selectedResident}
        loading={loading}
      />
    </div>
  )
}
