"use client";

import { useState } from "react";
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
} from "recharts";

const data = [
  { month: "Jan", margin: 32 },
  { month: "Feb", margin: 30 },
  { month: "Mar", margin: 27 },
  { month: "Apr", margin: 24 },
  { month: "May", margin: 22 },
  { month: "Jun", margin: 20 },
];

export default function Home() {
  const [question, setQuestion] = useState("");
  const [response, setResponse] = useState("");

  const askQuestion = () => {
     if (!question.trim()) {
    setResponse("");
    return;
  }

    setResponse(
      "European margin decreased because operating costs increased while sales growth slowed."
    );
  };

  return (
    <main className="min-h-screen bg-gray-50 p-8">
      <div className="mx-auto max-w-5xl">
        <h1 className="text-4xl font-bold text-gray-900">MetricMind</h1>

        <p className="mt-2 text-gray-600">
          Ask questions about your business data using AI.
        </p>

        <div className="mt-8 rounded-xl bg-white p-6 shadow">
          <label className="font-semibold text-gray-800">
            Ask your business question
          </label>

          <input
            type="text"
            value={question}
            onChange={(e) => setQuestion(e.target.value)}
            placeholder="Ask your business question..."
            className="mt-3 w-full rounded-lg border border-gray-300 p-3 outline-none focus:border-blue-500"
          />
        <p className="mt-3 text-sm text-gray-500">
  Example: Why did European margins drop?
</p>
          <button
            onClick={askQuestion}
            className="mt-4 rounded-lg bg-blue-600 px-5 py-3 font-semibold text-white hover:bg-blue-700"
          >
            Ask
          </button>
        </div>

        {response && (
          <>
            <div className="mt-6 rounded-xl bg-white p-6 shadow">
              <h2 className="text-xl font-bold text-gray-900">
                AI Response
              </h2>

              <p className="mt-3 text-gray-700">{response}</p>
            </div>

            <div className="mt-6 rounded-xl bg-white p-6 shadow">
              <h2 className="mb-4 text-xl font-bold text-gray-900">
                European Margin Trend
              </h2>

              <div className="h-80 w-full">
                <ResponsiveContainer width="100%" height="100%">
                  <BarChart data={data}>
                    <CartesianGrid strokeDasharray="3 3" />
                    <XAxis dataKey="month" />
                    <YAxis />
                    <Tooltip />
                    <Bar dataKey="margin" />
                  </BarChart>
                </ResponsiveContainer>
              </div>
            </div>
          </>
        )}
      </div>
    </main>
  );
}