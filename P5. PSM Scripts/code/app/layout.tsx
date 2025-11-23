import type React from "react"
import type { Metadata } from "next"
import Sidebar from "@/components/sidebar"
import "./globals.css"

export const metadata: Metadata = {
  title: "ApartHub - Property Management",
  description: "Comprehensive apartment management system",
    generator: 'v0.app'
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body className="bg-background">
        <div className="flex h-screen">
          <Sidebar />
          <main className="flex-1 overflow-auto">
            <div className="p-8">{children}</div>
          </main>
        </div>
      </body>
    </html>
  )
}
