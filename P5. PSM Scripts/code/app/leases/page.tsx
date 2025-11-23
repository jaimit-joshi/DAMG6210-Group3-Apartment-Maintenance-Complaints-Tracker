"use client"

import { useState, useEffect } from "react"
import DataTable from "@/components/data-table"
import FormModal from "@/components/form-modal"
import type { Lease } from "@/lib/types"

const columns = [
  { key: "LeaseID", label: "ID", sortable: true },
  { key: "ResidentID", label: "Resident", sortable: true },
  { key: "UnitID", label: "Unit", sortable: true },
  { key: "LeaseStartDate", label: "Start Date" },
  { key: "LeaseEndDate", label: "End Date" },
  { key: "MonthlyRentAmount", label: "Monthly Rent" },
  { key: "LeaseStatus", label: "Status" },
]

const formFields = [
  { name: "ResidentID", label: "Resident", type: "select" as const, required: true, endpoint: "/api/residents" },
  { name: "UnitID", label: "Unit", type: "select" as const, required: true, endpoint: "/api/units" },
  { name: "PreparedByManagerID", label: "Manager", type: "select" as const, required: true, endpoint: "/api/managers" },
  { name: "LeaseStartDate", label: "Start Date", type: "date" as const, required: true },
  { name: "LeaseEndDate", label: "End Date", type: "date" as const, required: true },
  { name: "MonthlyRentAmount", label: "Monthly Rent", type: "number" as const, required: true, step: "0.01" },
  { name: "SecurityDepositAmount", label: "Security Deposit", type: "number" as const, required: true, step: "0.01" },
  { name: "PetDepositAmount", label: "Pet Deposit", type: "number" as const, step: "0.01" },
  { name: "PaymentDueDay", label: "Payment Due Day (1-31)", type: "number" as const, required: true, min: 1, max: 31 },
  { name: "LateFeeAmount", label: "Late Fee Amount", type: "number" as const, step: "0.01" },
  { name: "GracePeriodDays", label: "Grace Period (Days)", type: "number" as const },
  { name: "SignedDate", label: "Signed Date", type: "date" as const },
  { name: "MoveInDate", label: "Move In Date", type: "date" as const },
  { name: "MoveOutDate", label: "Move Out Date", type: "date" as const },
  { name: "TerminationReason", label: "Termination Reason", type: "text" as const },
  {
    name: "LeaseStatus",
    label: "Status",
    type: "select" as const,
    required: true,
    options: [
      { value: "Draft", label: "Draft" },
      { value: "Active", label: "Active" },
      { value: "Completed", label: "Completed" },
      { value: "Terminated", label: "Terminated" },
    ],
  },
]

export default function LeasesPage() {
  const [leases, setLeases] = useState<Lease[]>([])
  const [isModalOpen, setIsModalOpen] = useState(false)
  const [selectedLease, setSelectedLease] = useState<Lease | null>(null)
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    fetchLeases()
  }, [])

  async function fetchLeases() {
    try {
      const response = await fetch("/api/leases")
      const data = await response.json()
      setLeases(data)
    } catch (error) {
      console.error("Error fetching leases:", error)
    }
  }

  const handleAdd = () => {
    setSelectedLease(null)
    setIsModalOpen(true)
  }

  const handleEdit = (lease: Lease) => {
    setSelectedLease(lease)
    setIsModalOpen(true)
  }

  const handleDelete = async (lease: Lease) => {
    if (confirm(`Delete lease ${lease.LeaseID}?`)) {
      try {
        const response = await fetch(`/api/leases?id=${lease.LeaseID}`, {
          method: "DELETE",
        })

        if (response.ok) {
          await fetchLeases()
        } else {
          const data = await response.json()
          alert(`Error: ${data.error}`)
        }
      } catch (error) {
        alert("Error deleting lease")
      }
    }
  }

  const handleSubmit = async (data: any) => {
    setLoading(true)
    try {
      const isEdit = selectedLease && selectedLease.LeaseID
      const method = isEdit ? "PUT" : "POST"
      const url = "/api/leases"

      const payload: any = { ...data }
      if (isEdit) {
        payload.LeaseID = selectedLease.LeaseID
      }

      const response = await fetch(url, {
        method,
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload),
      })

      if (response.ok) {
        await fetchLeases()
        setIsModalOpen(false)
      } else {
        const errorData = await response.json()
        alert(`Error: ${errorData.error}`)
      }
    } catch (error) {
      alert("Error saving lease")
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold text-foreground">Leases</h1>
        <p className="text-gray-600 mt-1">Manage tenant leases and agreements</p>
      </div>

      <DataTable
        columns={columns}
        data={leases}
        onEdit={handleEdit}
        onDelete={handleDelete}
        onAdd={handleAdd}
        title="Leases List"
      />

      <FormModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        onSubmit={handleSubmit}
        title={selectedLease ? "Edit Lease" : "Add Lease"}
        fields={formFields}
        initialData={selectedLease}
        loading={loading}
      />
    </div>
  )
}
