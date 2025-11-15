import { BrowserRouter as Router, Routes, Route } from 'react-router-dom'
import HomePage from './pages/HomePage'
import IssuerDetailPage from './pages/IssuerDetailPage'
import './App.css'

function App() {
  return (
    <Router>
      <div className="min-h-screen bg-gray-50">
        <nav className="bg-white shadow-sm">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="flex justify-between h-16">
              <div className="flex items-center">
                <h1 className="text-2xl font-bold text-primary-600">MuniLens</h1>
                <p className="ml-4 text-sm text-gray-500">AI-Powered Credit Risk Assessment</p>
              </div>
            </div>
          </div>
        </nav>
        
        <main>
          <Routes>
            <Route path="/" element={<HomePage />} />
            <Route path="/issuer/:id" element={<IssuerDetailPage />} />
          </Routes>
        </main>
      </div>
    </Router>
  )
}

export default App
