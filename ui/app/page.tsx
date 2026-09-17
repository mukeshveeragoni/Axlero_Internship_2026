"use client";

import { useState } from "react";
import DynamicChart from "../components/DynamicChart";

type ChartRow = Record<string, string | number>;

const monthlySales: ChartRow[] = [
  { month: "Jan", sales: 45000 },
  { month: "Feb", sales: 52000 },
  { month: "Mar", sales: 48000 },
  { month: "Apr", sales: 61000 },
  { month: "May", sales: 68000 },
  { month: "Jun", sales: 72000 },
];

const regionalSales: ChartRow[] = [
  { region: "Asia", sales: 72000 },
  { region: "Europe", sales: 58000 },
  { region: "North America", sales: 64000 },
  { region: "Africa", sales: 31000 },
];

export default function Home() {
  const [question, setQuestion] = useState("");
  const [response, setResponse] = useState("");
  const [chartData, setChartData] = useState<ChartRow[]>([]);
  const [chartTitle, setChartTitle] = useState("");

  const askQuestion = () => {
    const q = question.toLowerCase();

    if (!q.trim()) {
      setResponse("");
      setChartData([]);
      return;
    }

    if (
      q.includes("monthly") ||
      q.includes("month") ||
      q.includes("trend")
    ) {
      setResponse("Here is the monthly sales trend.");
      setChartTitle("Monthly Sales");
      setChartData(monthlySales);
      return;
    }

    if (q.includes("region") || q.includes("regional")) {
      setResponse("Here are the sales figures by region.");
      setChartTitle("Sales by Region");
      setChartData(regionalSales);
      return;
    }

    if (q.includes("european") && q.includes("margin")) {
      setResponse(
        "European margin decreased because operating costs increased while sales growth slowed."
      );

      setChartTitle("European Margin Trend");

      setChartData([
        { month: "Jan", margin: 32 },
        { month: "Feb", margin: 30 },
        { month: "Mar", margin: 27 },
        { month: "Apr", margin: 24 },
        { month: "May", margin: 22 },
        { month: "Jun", margin: 20 },
      ]);

      return;
    }

    setResponse(
      "I could not identify a visualization type for this question yet."
    );
    setChartData([]);
    setChartTitle("");
  };

  return (
    <main className="min-h-screen bg-gray-50 p-8">
      <div className="mx-auto max-w-5xl">
        <h1 className="text-4xl font-bold text-gray-900">
          MetricMind
        </h1>

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
            Examples:
            <br />
            • Show monthly sales
            <br />
            • Show sales by region
            <br />
            • Why did European margins drop?
          </p>

          <button
            onClick={askQuestion}
            className="mt-4 rounded-lg bg-blue-600 px-5 py-3 font-semibold text-white hover:bg-blue-700"
          >
            Ask
          </button>
        </div>

        {response && (
          <div className="mt-6 rounded-xl bg-white p-6 shadow">
            <h2 className="text-xl font-bold text-gray-900">
              AI Response
            </h2>

            <p className="mt-3 text-gray-700">
              {response}
            </p>
          </div>
        )}

        {chartData.length > 0 && (
          <DynamicChart
            data={chartData}
            title={chartTitle}
          />
        )}
      </div>
    </main>
  );
}