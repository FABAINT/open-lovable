import { NextResponse } from 'next/server';

export async function GET() {
  try {
    // Basic health check
    const healthInfo = {
      status: 'healthy',
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
      memory: process.memoryUsage(),
      environment: process.env.NODE_ENV || 'development'
    };

    return NextResponse.json(healthInfo);
  } catch (error) {
    return NextResponse.json(
      { 
        status: 'unhealthy', 
        error: (error as Error).message,
        timestamp: new Date().toISOString()
      }, 
      { status: 500 }
    );
  }
}