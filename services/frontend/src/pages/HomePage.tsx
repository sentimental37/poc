import { useEffect, useState } from 'react'
import axios from 'axios'

interface ApiStatus {
  api: string
  database: string
  graph_db: string
  cache: string
}

function HomePage() {
  const [status, setStatus] = useState<ApiStatus | null>(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    const fetchStatus = async () => {
      try {
        const response = await axios.get<ApiStatus>('/api/v1/status')
        setStatus(response.data)
      } catch (error) {
        console.error('Failed to fetch API status:', error)
      } finally {
        setLoading(false)
      }
    }

    fetchStatus()
  }, [])

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <div className="text-center">
        <h2 className="text-3xl font-bold text-gray-900 mb-4">
          Welcome to MuniLens
        </h2>
        <p className="text-lg text-gray-600 mb-8">
          AI-Powered Disclosure Intelligence System for Dynamic Credit Risk Assessment
        </p>

        <div className="bg-white shadow rounded-lg p-6 max-w-2xl mx-auto">
          <h3 className="text-xl font-semibold text-gray-900 mb-4">System Status</h3>
          
          {loading ? (
            <p className="text-gray-500">Loading...</p>
          ) : status ? (
            <div className="space-y-2">
              <StatusItem label="API" status={status.api} />
              <StatusItem label="Database" status={status.database} />
              <StatusItem label="Graph Database" status={status.graph_db} />
              <StatusItem label="Cache" status={status.cache} />
            </div>
          ) : (
            <p className="text-red-500">Failed to load system status</p>
          )}
        </div>

        <div className="mt-8 grid grid-cols-1 md:grid-cols-3 gap-6">
          <FeatureCard
            title="Data Ingestion"
            description="Automated scraping of EMMA, SEC EDGAR, and other financial disclosure sources"
          />
          <FeatureCard
            title="AI Extraction"
            description="LLM-powered extraction of fiscal metrics from unstructured documents"
          />
          <FeatureCard
            title="Risk Scoring"
            description="Ensemble ML models generating explainable credit risk scores"
          />
        </div>
      </div>
    </div>
  )
}

function StatusItem({ label, status }: { label: string; status: string }) {
  const isOperational = status === 'operational'
  const statusColor = isOperational ? 'text-green-600' : 'text-yellow-600'
  
  return (
    <div className="flex justify-between items-center py-2 border-b border-gray-200 last:border-b-0">
      <span className="text-gray-700 font-medium">{label}</span>
      <span className={`${statusColor} font-semibold`}>
        {status.replace('_', ' ')}
      </span>
    </div>
  )
}

function FeatureCard({ title, description }: { title: string; description: string }) {
  return (
    <div className="bg-white shadow rounded-lg p-6">
      <h4 className="text-lg font-semibold text-gray-900 mb-2">{title}</h4>
      <p className="text-gray-600 text-sm">{description}</p>
    </div>
  )
}

export default HomePage
