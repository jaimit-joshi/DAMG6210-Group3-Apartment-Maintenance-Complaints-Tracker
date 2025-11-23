"use client"

import type React from "react"

import { X } from "lucide-react"
import { useState, useEffect } from "react"

interface FormField {
  name: string
  label: string
  type: "text" | "email" | "number" | "date" | "select" | "textarea" | "checkbox"
  required?: boolean
  options?: { value: string; label: string }[]
  endpoint?: string // add endpoint for dynamic FK options
}

interface FormModalProps {
  isOpen: boolean
  onClose: () => void
  onSubmit: (data: any) => void
  title: string
  fields: FormField[]
  initialData?: any
  loading?: boolean
}

export default function FormModal({ isOpen, onClose, onSubmit, title, fields, initialData, loading }: FormModalProps) {
  const [formData, setFormData] = useState<any>({})
  const [dynamicOptions, setDynamicOptions] = useState<Record<string, { value: string; label: string }[]>>({})
  const [loadingOptions, setLoadingOptions] = useState(false)

  useEffect(() => {
    if (!isOpen) return

    const fetchAllOptions = async () => {
      setLoadingOptions(true)
      const options: Record<string, { value: string; label: string }[]> = {}

      for (const field of fields) {
        if (field.endpoint) {
          try {
            const res = await fetch(field.endpoint)
            const data = await res.json()

            // Convert API response to options based on field name
            const opts = data.map((item: any) => {
              let idField = "ID"
              let labelFields: string[] = []

              // Determine ID and label fields based on endpoint
              if (field.endpoint.includes("residents")) {
                idField = "ResidentID"
                labelFields = ["FirstName", "LastName", "EmailAddress"]
              } else if (field.endpoint.includes("buildings")) {
                idField = "BuildingID"
                labelFields = ["BuildingName"]
              } else if (field.endpoint.includes("units")) {
                idField = "UnitID"
                labelFields = ["UnitNumber", "BuildingID"]
              } else if (field.endpoint.includes("managers")) {
                idField = "ManagerID"
                labelFields = ["FirstName", "LastName", "JobTitle"]
              } else if (field.endpoint.includes("vendors")) {
                idField = "VendorID"
                labelFields = ["CompanyName", "PrimaryContactName"]
              } else if (field.endpoint.includes("leases")) {
                idField = "LeaseID"
                labelFields = ["LeaseID", "ResidentID", "UnitID"]
              } else if (field.endpoint.includes("maintenance") && !field.endpoint.includes("categories")) {
                idField = "RequestID"
                labelFields = ["RequestID", "RequestTitle"]
              } else if (field.endpoint.includes("maintenance-categories")) {
                idField = "CategoryID"
                labelFields = ["CategoryName"]
              } else if (field.endpoint.includes("work-orders")) {
                idField = "WorkOrderID"
                labelFields = ["WorkOrderNumber"]
              }

              const label = labelFields
                .map((f) => item[f])
                .filter(Boolean)
                .join(" - ")

              return {
                value: String(item[idField]),
                label: label || `ID: ${item[idField]}`,
              }
            })

            options[field.name] = opts
          } catch (error) {
            console.error(`[v0] Error fetching options for ${field.name}:`, error)
            options[field.name] = []
          }
        }
      }

      setDynamicOptions(options)
      setLoadingOptions(false)
    }

    fetchAllOptions()
  }, [isOpen, fields])

  useEffect(() => {
    if (initialData) {
      const filteredData: any = {}
      fields.forEach((field) => {
        filteredData[field.name] = initialData[field.name] || ""
      })
      setFormData(filteredData)
    } else {
      const emptyData: any = {}
      fields.forEach((field) => {
        emptyData[field.name] = ""
      })
      setFormData(emptyData)
    }
  }, [initialData, isOpen, fields])

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    onSubmit(formData)
  }

  const handleChange = (name: string, value: any) => {
    setFormData((prev: any) => ({ ...prev, [name]: value }))
  }

  if (!isOpen) return null

  return (
    <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4 overflow-y-auto">
      <div className="bg-surface rounded-lg shadow-xl w-full max-w-md my-8 flex flex-col max-h-[calc(100vh-4rem)]">
        {/* Header - fixed at top */}
        <div className="flex items-center justify-between p-4 border-b border-border flex-shrink-0">
          <h3 className="text-lg font-semibold">{title}</h3>
          <button onClick={onClose} className="p-1 hover:bg-gray-200 rounded transition" type="button">
            <X size={20} />
          </button>
        </div>

        <form onSubmit={handleSubmit} className="flex flex-col flex-1 min-h-0">
          {/* Scrollable content area */}
          <div className="overflow-y-auto flex-1 p-4 space-y-3">
            {fields.map((field) => (
              <div key={field.name}>
                <label className="block text-sm font-medium mb-1">
                  {field.label}
                  {field.required && <span className="text-error ml-1">*</span>}
                </label>

                {field.type === "textarea" ? (
                  <textarea
                    name={field.name}
                    value={formData[field.name] || ""}
                    onChange={(e) => handleChange(field.name, e.target.value)}
                    required={field.required}
                    className="w-full px-3 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-secondary resize-none h-16 text-sm"
                  />
                ) : field.type === "select" ? (
                  <select
                    name={field.name}
                    value={formData[field.name] || ""}
                    onChange={(e) => handleChange(field.name, e.target.value)}
                    required={field.required}
                    disabled={loadingOptions && field.endpoint}
                    className="w-full px-3 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-secondary text-sm"
                  >
                    <option value="">
                      {loadingOptions && field.endpoint ? "Loading..." : `Select ${field.label}`}
                    </option>
                    {(dynamicOptions[field.name] || field.options || []).map((opt) => (
                      <option key={opt.value} value={opt.value}>
                        {opt.label}
                      </option>
                    ))}
                  </select>
                ) : field.type === "checkbox" ? (
                  <input
                    type="checkbox"
                    name={field.name}
                    checked={formData[field.name] || false}
                    onChange={(e) => handleChange(field.name, e.target.checked)}
                    className="w-4 h-4"
                  />
                ) : (
                  <input
                    type={field.type}
                    name={field.name}
                    value={formData[field.name] || ""}
                    onChange={(e) => handleChange(field.name, e.target.value)}
                    required={field.required}
                    className="w-full px-3 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-secondary text-sm"
                  />
                )}
              </div>
            ))}
          </div>

          <div className="flex gap-3 p-4 border-t border-border flex-shrink-0 bg-surface">
            <button
              type="button"
              onClick={onClose}
              className="flex-1 px-4 py-2 border border-border rounded-lg hover:bg-gray-100 transition text-sm font-medium"
            >
              Cancel
            </button>
            <button
              type="submit"
              disabled={loading || loadingOptions}
              className="flex-1 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition disabled:opacity-50 text-sm font-medium"
            >
              {loading ? "Saving..." : "Save"}
            </button>
          </div>
        </form>
      </div>
    </div>
  )
}
