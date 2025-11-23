"use client"

import { useState, useEffect } from "react"
import DataTable from "@/components/data-table"
import FormModal from "@/components/form-modal"
import type { WorkOrder } from "@/lib/types"

const columns = [
  { key: "WorkOrderNumber", label: "Number", sortable: true },
  { key: "RequestID", label: "Request ID" },
  { key: "UnitID", label: "Unit", sortable: true },
  { key: "CreatedByManagerID", label: "Created By" },
  { key: "VendorID", label: "Vendor" },
  { key: "WorkType", label: "Type", sortable: true },
  { key: "WorkDescription", label: "Description" },
  { key: "ScheduledDate", label: "Scheduled" },
  { key: "StartDateTime", label: "Start" },
  { key: "CompletionDateTime", label: "Completed" },
  { key: "WorkStatus", label: "Status" },
  { key: "EstimatedCost", label: "Est. Cost" },
  { key: "ActualCost", label: "Actual Cost" },
  { key: "RequiresApproval", label: "Needs Approval" },
  { key: "ApprovedByManagerID", label: "Approved By" },
  { key: "ApprovalDate", label: "Approval Date" },
]

const formFields = [
  { name: "WorkOrderNumber", label: "Work Order Number", type: "text" as const, required: true },
  { name: "RequestID", label: "Request", type: "select" as const, endpoint: "/api/maintenance" },
  { name: "UnitID", label: "Unit", type: "select" as const, required: true, endpoint: "/api/units" },
  {
    name: "CreatedByManagerID",
    label: "Created By Manager",
    type: "select" as const,
    required: true,
    endpoint: "/api/managers",
  },
  { name: "VendorID", label: "Vendor", type: "select" as const, endpoint: "/api/vendors" },
  { name: "WorkType", label: "Work Type", type: "text" as const, required: true },
  {
    name: "WorkDescription",
    label: "Description (max 200 chars)",
    type: "textarea" as const,
    required: true,
    maxLength: 200,
  },
  { name: "ScheduledDate", label: "Scheduled Date", type: "date" as const },
  { name: "StartDateTime", label: "Start Date/Time", type: "datetime-local" as const },
  { name: "CompletionDateTime", label: "Completion Date/Time", type: "datetime-local" as const },
  {
    name: "WorkStatus",
    label: "Status",
    type: "select" as const,
    required: true,
    options: [
      { value: "Pending", label: "Pending" },
      { value: "Scheduled", label: "Scheduled" },
      { value: "In Progress", label: "In Progress" },
      { value: "Completed", label: "Completed" },
      { value: "Cancelled", label: "Cancelled" },
    ],
  },
  { name: "EstimatedCost", label: "Estimated Cost", type: "number" as const, step: "0.01" },
  { name: "ActualCost", label: "Actual Cost", type: "number" as const, step: "0.01" },
  { name: "RequiresApproval", label: "Requires Approval", type: "checkbox" as const },
  { name: "ApprovedByManagerID", label: "Approved By Manager", type: "select" as const, endpoint: "/api/managers" },
  { name: "ApprovalDate", label: "Approval Date", type: "datetime-local" as const },
]

export default function WorkOrdersPage() {
  const [workOrders, setWorkOrders] = useState<WorkOrder[]>([])
  const [isModalOpen, setIsModalOpen] = useState(false)
  const [selectedWorkOrder, setSelectedWorkOrder] = useState<WorkOrder | null>(null)
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    fetchWorkOrders()
  }, [])

  async function fetchWorkOrders() {
    try {
      const response = await fetch("/api/work-orders")
      const data = await response.json()
      setWorkOrders(data)
    } catch (error) {
      console.error("Error fetching work orders:", error)
    }
  }

  const handleAdd = () => {
    setSelectedWorkOrder(null)
    setIsModalOpen(true)
  }

  const handleEdit = (workOrder: WorkOrder) => {
    setSelectedWorkOrder(workOrder)
    setIsModalOpen(true)
  }

  const handleDelete = async (workOrder: WorkOrder) => {
    if (confirm(`Delete work order ${workOrder.WorkOrderNumber}?`)) {
      try {
        const response = await fetch(`/api/work-orders?id=${workOrder.WorkOrderID}`, {
          method: "DELETE",
        })

        if (response.ok) {
          await fetchWorkOrders()
        } else {
          const data = await response.json()
          alert(`Error: ${data.error}`)
        }
      } catch (error) {
        alert("Error deleting work order")
      }
    }
  }

  const handleSubmit = async (data: any) => {
    setLoading(true)
    try {
      const isEdit = selectedWorkOrder && selectedWorkOrder.WorkOrderID
      const method = isEdit ? "PUT" : "POST"
      const url = "/api/work-orders"

      const payload: any = { ...data }
      if (isEdit) {
        payload.WorkOrderID = selectedWorkOrder.WorkOrderID
      }

      const response = await fetch(url, {
        method,
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload),
      })

      if (response.ok) {
        await fetchWorkOrders()
        setIsModalOpen(false)
      } else {
        const errorData = await response.json()
        alert(`Error: ${errorData.error}`)
      }
    } catch (error) {
      alert("Error saving work order")
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold text-foreground">Work Orders</h1>
        <p className="text-gray-600 mt-1">Schedule and track maintenance work</p>
      </div>

      <DataTable
        columns={columns}
        data={workOrders}
        onEdit={handleEdit}
        onDelete={handleDelete}
        onAdd={handleAdd}
        title="Work Orders"
      />

      <FormModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        onSubmit={handleSubmit}
        title={selectedWorkOrder ? "Edit Work Order" : "Add Work Order"}
        fields={formFields}
        initialData={selectedWorkOrder}
        loading={loading}
      />
    </div>
  )
}
