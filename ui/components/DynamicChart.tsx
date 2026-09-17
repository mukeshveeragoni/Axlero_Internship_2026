"use client";

import {
  Bar,
  BarChart,
  CartesianGrid,
  Line,
  LineChart,
  ResponsiveContainer,
  Tooltip,
  XAxis,
  YAxis,
} from "recharts";

type ChartRow = Record<string, string | number>;

interface DynamicChartProps {
  data: ChartRow[];
  title?: string;
}

function isTimeKey(key: string): boolean {
  const name = key.toLowerCase();

  return (
    name.includes("date") ||
    name.includes("month") ||
    name.includes("year") ||
    name.includes("time") ||
    name.includes("week") ||
    name.includes("quarter")
  );
}

function isNumber(value: unknown): boolean {
  return typeof value === "number" && !Number.isNaN(value);
}

export default function DynamicChart({
  data,
  title = "Data Visualization",
}: DynamicChartProps) {
  if (!data || data.length === 0) {
    return (
      <div className="mt-6 rounded-xl bg-white p-6 shadow">
        <p className="text-gray-500">
          No data available for visualization.
        </p>
      </div>
    );
  }

  const keys = Object.keys(data[0]);

  const dimensionKey =
    keys.find((key) => isTimeKey(key)) ??
    keys.find((key) => typeof data[0][key] === "string");

  const measureKey = keys.find((key) =>
    data.some((row) => isNumber(row[key]))
  );

  if (!dimensionKey || !measureKey) {
    return (
      <div className="mt-6 rounded-xl bg-white p-6 shadow">
        <p className="text-gray-500">
          Unable to create a chart from the returned data.
        </p>
      </div>
    );
  }

  if (isTimeKey(dimensionKey)) {
    return (
      <div className="mt-6 rounded-xl bg-white p-6 shadow">
        <h2 className="mb-4 text-xl font-bold">
          {title}
        </h2>

        <div className="h-80 w-full">
          <ResponsiveContainer width="100%" height="100%">
            <LineChart data={data}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey={dimensionKey} />
              <YAxis />
              <Tooltip />
              <Line
                type="monotone"
                dataKey={measureKey}
                strokeWidth={2}
              />
            </LineChart>
          </ResponsiveContainer>
        </div>
      </div>
    );
  }

  return (
    <div className="mt-6 rounded-xl bg-white p-6 shadow">
      <h2 className="mb-4 text-xl font-bold">
        {title}
      </h2>

      <div className="h-80 w-full">
        <ResponsiveContainer width="100%" height="100%">
          <BarChart data={data}>
            <CartesianGrid strokeDasharray="3 3" />
            <XAxis dataKey={dimensionKey} />
            <YAxis />
            <Tooltip />
            <Bar dataKey={measureKey} />
          </BarChart>
        </ResponsiveContainer>
      </div>
    </div>
  );
}
