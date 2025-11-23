"use client"

import { useState } from "react"
import { ChevronLeft, ChevronRight, Edit2, Trash2, Plus, Search } from "lucide-react"

interface Column {
  key: string
  label: string
  sortable?: boolean
}

interface DataTableProps {
  columns: Column[]
  data: any[]
  onEdit?: (row: any) => void
  onDelete?: (row: any) => void
  onAdd?: () => void
  title: string
}

export default function DataTable({ columns, data, onEdit, onDelete, onAdd, title }: DataTableProps) {
  const [searchTerm, setSearchTerm] = useState("")
  const [sortKey, setSortKey] = useState<string | null>(null)
  const [sortDir, setSortDir] = useState<"asc" | "desc">("asc")
  const [page, setPage] = useState(0)
  const pageSize = 10

  console.log("[v0] DataTable rendering with data:", data.slice(0, 1))
  console.log(
    "[v0] Column keys:",
    columns.map((c) => c.key),
  )
  if (data.length > 0) {
    console.log("[v0] First row keys:", Object.keys(data[0]))
    console.log(
      "[v0] Sample values:",
      columns.map((col) => ({ key: col.key, value: data[0][col.key] })),
    )
  }

  // Filter data
  const filteredData = data.filter((row) =>
    columns.some((col) => String(row[col.key]).toLowerCase().includes(searchTerm.toLowerCase())),
  )

  // Sort data
  const sortedData = [...filteredData].sort((a, b) => {
    if (!sortKey) return 0
    const aVal = a[sortKey]
    const bVal = b[sortKey]
    if (aVal < bVal) return sortDir === "asc" ? -1 : 1
    if (aVal > bVal) return sortDir === "asc" ? 1 : -1
    return 0
  })

  // Paginate
  const totalPages = Math.ceil(sortedData.length / pageSize)
  const paginatedData = sortedData.slice(page * pageSize, (page + 1) * pageSize)

  const handleSort = (key: string) => {
    if (sortKey === key) {
      setSortDir(sortDir === "asc" ? "desc" : "asc")
    } else {
      setSortKey(key)
      setSortDir("asc")
    }
  }

  return (
    <div className="bg-surface rounded-lg shadow">
      {/* Header */}
      <div className="p-6 border-b border-border flex items-center justify-between">
        <h2 className="text-xl font-semibold">{title}</h2>
        {onAdd && (
          <button
            onClick={onAdd}
            className="flex items-center gap-2 bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition"
          >
            <Plus size={20} />
            Add New
          </button>
        )}
      </div>

      {/* Search */}
      <div className="p-4 border-b border-border">
        <div className="relative">
          <Search size={20} className="absolute left-3 top-2.5 text-gray-400" />
          <input
            type="text"
            placeholder="Search..."
            value={searchTerm}
            onChange={(e) => {
              setSearchTerm(e.target.value)
              setPage(0)
            }}
            className="w-full pl-10 pr-4 py-2 border border-border rounded-lg focus:outline-none focus:ring-2 focus:ring-secondary"
          />
        </div>
      </div>

      {/* Table */}
      <div className="overflow-x-auto">
        <table className="w-full">
          <thead>
            <tr className="bg-surface-variant border-b border-border">
              {columns.map((col) => (
                <th
                  key={col.key}
                  onClick={() => col.sortable && handleSort(col.key)}
                  className={`px-6 py-3 text-left font-semibold text-sm ${
                    col.sortable ? "cursor-pointer hover:bg-gray-200" : ""
                  }`}
                >
                  {col.label}
                  {sortKey === col.key && <span className="ml-2">{sortDir === "asc" ? "↑" : "↓"}</span>}
                </th>
              ))}
              <th className="px-6 py-3 text-left font-semibold text-sm">Actions</th>
            </tr>
          </thead>
          <tbody>
            {paginatedData.length > 0 ? (
              paginatedData.map((row, idx) => (
                <tr key={idx} className="border-b border-border hover:bg-surface-variant transition">
                  {columns.map((col) => (
                    <td key={col.key} className="px-6 py-3 text-sm">
                      {String(row[col.key] || "-")}
                    </td>
                  ))}
                  <td className="px-6 py-3 text-sm flex gap-2">
                    {onEdit && (
                      <button
                        onClick={() => onEdit(row)}
                        className="p-1 hover:bg-blue-100 rounded transition"
                        title="Edit"
                      >
                        <Edit2 size={18} className="text-blue-600" />
                      </button>
                    )}
                    {onDelete && (
                      <button
                        onClick={() => onDelete(row)}
                        className="p-1 hover:bg-red-100 rounded transition"
                        title="Delete"
                      >
                        <Trash2 size={18} className="text-red-600" />
                      </button>
                    )}
                  </td>
                </tr>
              ))
            ) : (
              <tr>
                <td colSpan={columns.length + 1} className="px-6 py-8 text-center text-gray-500">
                  No data found
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>

      {/* Pagination */}
      <div className="px-6 py-4 border-t border-border flex items-center justify-between">
        <div className="text-sm text-gray-600">
          Showing {paginatedData.length > 0 ? page * pageSize + 1 : 0} to{" "}
          {Math.min((page + 1) * pageSize, sortedData.length)} of {sortedData.length}
        </div>
        <div className="flex gap-2">
          <button
            onClick={() => setPage(Math.max(0, page - 1))}
            disabled={page === 0}
            className="p-2 hover:bg-gray-200 rounded disabled:opacity-50 transition"
          >
            <ChevronLeft size={20} />
          </button>
          <span className="px-4 py-2 text-sm">
            Page {page + 1} of {totalPages || 1}
          </span>
          <button
            onClick={() => setPage(Math.min(totalPages - 1, page + 1))}
            disabled={page >= totalPages - 1}
            className="p-2 hover:bg-gray-200 rounded disabled:opacity-50 transition"
          >
            <ChevronRight size={20} />
          </button>
        </div>
      </div>
    </div>
  )
}
