import { useParams } from 'react-router-dom'

function IssuerDetailPage() {
  const { id } = useParams<{ id: string }>()

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <h2 className="text-2xl font-bold text-gray-900 mb-4">
        Issuer Detail: {id}
      </h2>
      <div className="bg-white shadow rounded-lg p-6">
        <p className="text-gray-600">
          Issuer detail page - Coming soon
        </p>
      </div>
    </div>
  )
}

export default IssuerDetailPage
