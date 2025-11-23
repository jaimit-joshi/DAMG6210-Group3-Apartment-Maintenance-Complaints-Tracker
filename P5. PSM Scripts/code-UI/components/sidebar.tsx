"use client"

import Link from "next/link"
import { usePathname } from 'next/navigation'
import { Building2, Users, FileText, Wrench, DollarSign, LayoutDashboard, Briefcase, Truck, Home, Phone, UserPlus, Building, Sparkles, ClipboardList, UserCog, HardHat, AlertTriangle, Bell, Tag, ChevronDown } from 'lucide-react'
import { useState } from "react"

export default function Sidebar() {
  const pathname = usePathname()
  const [openSections, setOpenSections] = useState<Record<string, boolean>>({
    overview: true,
    property: true,
    people: true,
    leasing: true,
    operations: true,
    financial: true,
    system: false,
  })

  const toggleSection = (section: string) => {
    setOpenSections((prev) => ({ ...prev, [section]: !prev[section] }))
  }

  const navSections = [
    {
      id: "overview",
      label: "Overview",
      items: [
        { href: "/", icon: Home, label: "Home" },
        { href: "/dashboard", icon: LayoutDashboard, label: "Dashboard" },
      ],
    },
    {
      id: "property",
      label: "Property Management",
      items: [
        { href: "/buildings", icon: Building2, label: "Buildings" },
        { href: "/units", icon: Building, label: "Units" },
        { href: "/amenities", icon: Sparkles, label: "Amenities" },
        { href: "/building-amenities", icon: Building2, label: "Building Amenities" },
        { href: "/unit-amenities", icon: Building, label: "Unit Amenities" },
      ],
    },
    {
      id: "people",
      label: "People",
      items: [
        { href: "/residents", icon: Users, label: "Residents" },
        { href: "/managers", icon: Briefcase, label: "Managers" },
        { href: "/vendors", icon: Truck, label: "Vendors" },
        { href: "/workers", icon: HardHat, label: "Workers" },
      ],
    },
    {
      id: "leasing",
      label: "Leasing",
      items: [
        { href: "/leases", icon: FileText, label: "Leases" },
        { href: "/lease-occupants", icon: UserPlus, label: "Lease Occupants" },
      ],
    },
    {
      id: "operations",
      label: "Operations",
      items: [
        { href: "/maintenance", icon: Wrench, label: "Maintenance Requests" },
        { href: "/work-orders", icon: ClipboardList, label: "Work Orders" },
        { href: "/maintenance-categories", icon: Tag, label: "Categories" },
        { href: "/escalations", icon: AlertTriangle, label: "Escalations" },
        { href: "/manager-assignments", icon: UserCog, label: "Manager Assignments" },
        { href: "/worker-assignments", icon: ClipboardList, label: "Worker Assignments" },
      ],
    },
    {
      id: "financial",
      label: "Financial",
      items: [
        { href: "/invoices", icon: DollarSign, label: "Invoices" },
        { href: "/payments", icon: DollarSign, label: "Payments" },
      ],
    },
    {
      id: "system",
      label: "System",
      items: [
        { href: "/emergency-contacts", icon: Phone, label: "Emergency Contacts" },
        { href: "/notifications", icon: Bell, label: "Notifications" },
      ],
    },
  ]

  return (
    <aside className="w-64 bg-card border-r h-screen overflow-y-auto">
      <div className="p-6 border-b bg-gradient-to-br from-primary/5 to-accent/5">
        <div className="flex items-center gap-3">
          <div className="p-2 bg-primary rounded-lg">
            <Building2 className="text-primary-foreground" size={24} />
          </div>
          <div>
            <h1 className="text-xl font-bold text-foreground">ApartHub</h1>
            <p className="text-xs text-muted-foreground">Property Management</p>
          </div>
        </div>
      </div>
      <nav className="p-4">
        {navSections.map((section) => (
          <div key={section.id} className="mb-4">
            <button
              onClick={() => toggleSection(section.id)}
              className="flex items-center justify-between w-full px-3 py-2 text-xs font-semibold text-muted-foreground hover:text-foreground uppercase tracking-wider"
            >
              <span>{section.label}</span>
              <ChevronDown
                size={14}
                className={`transition-transform ${
                  openSections[section.id] ? "rotate-180" : ""
                }`}
              />
            </button>
            {openSections[section.id] && (
              <div className="mt-1 space-y-1">
                {section.items.map((item) => {
                  const Icon = item.icon
                  const isActive = pathname === item.href
                  return (
                    <Link
                      key={item.href}
                      href={item.href}
                      className={`flex items-center gap-3 px-3 py-2 rounded-md text-sm transition ${
                        isActive
                          ? "bg-primary text-primary-foreground"
                          : "text-muted-foreground hover:bg-muted hover:text-foreground"
                      }`}
                    >
                      <Icon size={18} />
                      <span>{item.label}</span>
                    </Link>
                  )
                })}
              </div>
            )}
          </div>
        ))}
      </nav>
    </aside>
  )
}
