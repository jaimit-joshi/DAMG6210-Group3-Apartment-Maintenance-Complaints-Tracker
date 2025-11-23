"use client"

import { useState, useEffect } from "react"
import DataTable from "@/components/data-table"
import FormModal from "@/components/form-modal"
import type { PropertyManager } from "@/lib/types"

const columns = [
  { key: "ManagerID", label: "ID", sortable: true },
  { key: "FirstName", label: "First Name", sortable: true },
  { key: "LastName", label: "Last Name", sortable: true },
  { key: "EmailAddress", label: "Email" },
  { key: "PhoneNumber", label: "Phone" },
  { key: "JobTitle", label: "Title" },
  { key: "ManagerRole", label: "Role" },
  { key: "AccountStatus", label: "Status" },
]

const formFields = [
  { name: "EmployeeID", label: "Employee ID", type: "text" as const, required: true },
  { name: "FirstName", label: "First Name", type: "text" as const, required: true },
  { name: "LastName", label: "Last Name", type: "text" as const, required: true },
  { name: "EmailAddress", label: "Email Address", type: "email" as const, required: true },
  { name: "PhoneNumber", label: "Phone Number", type: "text" as const, required: true },
  { name: "JobTitle", label: "Job Title", type: "text" as const, required: true },
  { name: "Department", label: "Department", type: "text" as const },
  { name: "HireDate", label: "Hire Date", type: "date" as const, required: true },
  {
    name: "ManagerRole",
    label: "Manager Role",
    type: "select" as const,
    options: [
      { value: "Admin", label: "Admin" },
      { value: "Manager", label: "Manager" },
      { value: "Supervisor", label: "Supervisor" },
      { value: "Staff", label: "Staff" },
    ],
  },
  { name: "MaxApprovalLimit", label: "Max Approval Limit", type: "number" as const },
  {
    name: "AccountStatus",
    label: "Account Status",
    type: "select" as const,
    options: [
      { value: "Active", label: "Active" },
      { value: "Inactive", label: "Inactive" },
      { value: "OnLeave", label: "On Leave" },
    ],
  },
]

export default function ManagersPage() {
  const [managers, setManagers] = useState<PropertyManager[]>([])
  const [isModalOpen, setIsModalOpen] = useState(false)
  const [selectedManager, setSelectedManager] = useState<PropertyManager | null>(null)
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    fetchManagers()
  }, [])

  async function fetchManagers() {
    try {
      const response = await fetch("/api/managers")
      const data = await response.json()
      setManagers(data)
    } catch (error) {
      console.error("Error fetching managers:", error)
    }
  }

  const handleAdd = () => {
    setSelectedManager(null)
    setIsModalOpen(true)
  }

  const handleEdit = (manager: PropertyManager) => {
    setSelectedManager(manager)
    setIsModalOpen(true)
  }

  const handleDelete = async (manager: PropertyManager) => {
    if (confirm(`Delete ${manager.FirstName} ${manager.LastName}?`)) {
      try {
        const response = await fetch(`/api/managers?id=${manager.ManagerID}`, {
          method: "DELETE",
        })

        if (response.ok) {
          await fetchManagers()
        } else {
          const data = await response.json()
          console.error("Delete error:", data.error)
        }
      } catch (error) {
        console.error("Error deleting manager:", error)
      }
    }
  }

  const handleSubmit = async (data: any) => {
    setLoading(true)
    try {
      const isEdit = selectedManager && selectedManager.ManagerID
      const method = isEdit ? "PUT" : "POST"
      const url = "/api/managers"

      const payload: any = { ...data }
      if (isEdit) {
        payload.ManagerID = selectedManager.ManagerID
      }

      const response = await fetch(url, {
        method,
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload),
      })

      if (response.ok) {
        await fetchManagers()
        setIsModalOpen(false)
      } else {
        const errorData = await response.json()
        console.error("Save error:", errorData.error)
      }
    } catch (error) {
      console.error("Error saving manager:", error)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold text-foreground">Managers</h1>
        <p className="text-gray-600 mt-1">Manage team members and staff</p>
      </div>

      <DataTable
        columns={columns}
        data={managers}
        onEdit={handleEdit}
        onDelete={handleDelete}
        onAdd={handleAdd}
        title="Managers List"
      />

      <FormModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        onSubmit={handleSubmit}
        title={selectedManager ? "Edit Manager" : "Add Manager"}
        fields={formFields}
        initialData={selectedManager}
        loading={loading}
      />
    </div>
  )
}
