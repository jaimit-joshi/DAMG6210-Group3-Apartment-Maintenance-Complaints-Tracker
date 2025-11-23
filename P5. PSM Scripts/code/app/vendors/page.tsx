"use client"

import { useState, useEffect } from "react"
import DataTable from "@/components/data-table"
import FormModal from "@/components/form-modal"
import type { VendorCompany } from "@/lib/types"

const columns = [
  { key: "VendorID", label: "ID", sortable: true },
  { key: "CompanyName", label: "Company", sortable: true },
  { key: "PrimaryContactName", label: "Contact" },
  { key: "PhoneNumber", label: "Phone" },
  { key: "EmailAddress", label: "Email" },
  { key: "VendorStatus", label: "Status" },
  { key: "IsPreferred", label: "Preferred" },
]

const formFields = [
  { name: "CompanyName", label: "Company Name", type: "text" as const, required: true },
  { name: "TaxID", label: "Tax ID", type: "text" as const, required: true },
  { name: "PrimaryContactName", label: "Contact Name", type: "text" as const, required: true },
  { name: "PhoneNumber", label: "Phone Number", type: "text" as const, required: true },
  { name: "EmailAddress", label: "Email Address", type: "email" as const, required: true },
  { name: "StreetAddress", label: "Street Address", type: "text" as const, required: true },
  { name: "City", label: "City", type: "text" as const, required: true },
  { name: "State", label: "State", type: "text" as const, required: true },
  { name: "ZipCode", label: "ZIP Code", type: "text" as const, required: true },
  { name: "LicenseNumber", label: "License Number", type: "text" as const },
  { name: "LicenseExpiryDate", label: "License Expiry Date", type: "date" as const },
  { name: "InsurancePolicyNumber", label: "Insurance Policy", type: "text" as const },
  { name: "InsuranceExpiryDate", label: "Insurance Expiry Date", type: "date" as const },
  {
    name: "VendorStatus",
    label: "Status",
    type: "select" as const,
    options: [
      { value: "Active", label: "Active" },
      { value: "Inactive", label: "Inactive" },
      { value: "Suspended", label: "Suspended" },
    ],
  },
  { name: "IsPreferred", label: "Preferred Vendor", type: "checkbox" as const },
]

export default function VendorsPage() {
  const [vendors, setVendors] = useState<VendorCompany[]>([])
  const [isModalOpen, setIsModalOpen] = useState(false)
  const [selectedVendor, setSelectedVendor] = useState<VendorCompany | null>(null)
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    fetchVendors()
  }, [])

  async function fetchVendors() {
    try {
      const response = await fetch("/api/vendors")
      const data = await response.json()
      setVendors(data)
    } catch (error) {
      console.error("Error fetching vendors:", error)
    }
  }

  const handleAdd = () => {
    setSelectedVendor(null)
    setIsModalOpen(true)
  }

  const handleEdit = (vendor: VendorCompany) => {
    setSelectedVendor(vendor)
    setIsModalOpen(true)
  }

  const handleDelete = async (vendor: VendorCompany) => {
    if (confirm(`Delete ${vendor.CompanyName}?`)) {
      try {
        const response = await fetch(`/api/vendors?id=${vendor.VendorID}`, {
          method: "DELETE",
        })

        if (response.ok) {
          await fetchVendors()
        } else {
          const data = await response.json()
          console.error("Delete error:", data.error)
        }
      } catch (error) {
        console.error("Error deleting vendor:", error)
      }
    }
  }

  const handleSubmit = async (data: any) => {
    setLoading(true)
    try {
      const isEdit = selectedVendor && selectedVendor.VendorID
      const method = isEdit ? "PUT" : "POST"
      const url = "/api/vendors"

      const payload: any = { ...data }
      if (isEdit) {
        payload.VendorID = selectedVendor.VendorID
      }

      const response = await fetch(url, {
        method,
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload),
      })

      if (response.ok) {
        await fetchVendors()
        setIsModalOpen(false)
      } else {
        const errorData = await response.json()
        console.error("Save error:", errorData.error)
      }
    } catch (error) {
      console.error("Error saving vendor:", error)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold text-foreground">Vendors</h1>
        <p className="text-gray-600 mt-1">Manage contractors and service providers</p>
      </div>

      <DataTable
        columns={columns}
        data={vendors}
        onEdit={handleEdit}
        onDelete={handleDelete}
        onAdd={handleAdd}
        title="Vendors List"
      />

      <FormModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        onSubmit={handleSubmit}
        title={selectedVendor ? "Edit Vendor" : "Add Vendor"}
        fields={formFields}
        initialData={selectedVendor}
        loading={loading}
      />
    </div>
  )
}
