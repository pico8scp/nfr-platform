export interface Config {
    webPort: number;
    apiPort: number;
    mcpAdminPort: number;
    dataDir: string;
    databasePath: string;
    realtimeTransport: 'sse' | 'websocket';
    agentRuntime: 'child_process' | 'worker_thread';
    bindHost: string;
}
export interface Session {
    id: string;
    title: string;
    description: string | null;
    status: 'active' | 'archived';
    createdAt: string;
    updatedAt: string;
    archivedAt: string | null;
    metadata: Record<string, unknown>;
}
export interface Conversation {
    id: string;
    sessionId: string;
    title: string | null;
    source: string;
    model: string | null;
    startedAt: string;
    lastTurnAt: string;
    status: 'open' | 'closed';
    parentConversationId: string | null;
    sharedMemoryScope: 'private' | 'session' | 'shared' | 'global';
    metadata: Record<string, unknown>;
}
export interface Turn {
    id: string;
    conversationId: string;
    sessionId: string;
    turnIndex: number;
    role: 'user' | 'assistant' | 'system' | 'tool';
    actorType: 'human' | 'agent' | 'system' | 'tool';
    actorId: string | null;
    contentText: string;
    contentJson: Record<string, unknown> | null;
    tokenCountInput: number | null;
    tokenCountOutput: number | null;
    eventTime: string;
    parentTurnId: string | null;
    visibility: 'default' | 'shared' | 'global';
    metadata: Record<string, unknown>;
}
export interface TurnAttachment {
    id: string;
    turnId: string;
    kind: 'code' | 'file' | 'image' | 'tool_output' | 'other';
    mimeType: string | null;
    title: string | null;
    contentText: string | null;
    contentJson: Record<string, unknown> | null;
    filePath: string | null;
    createdAt: string;
}
export interface MemoryLink {
    id: string;
    fromTurnId: string;
    toTurnId: string;
    linkType: 'references' | 'related' | 'derived' | 'responds_to';
    weight: number;
    createdAt: string;
    metadata: Record<string, unknown>;
}
export interface Agent {
    id: string;
    name: string;
    type: 'frontend-dev' | 'backend-dev' | 'research' | 'tester' | 'general' | 'orchestrator';
    status: 'idle' | 'busy' | 'offline';
    runtimeMode: 'child_process' | 'worker_thread';
    capabilities: string[];
    currentTaskId: string | null;
    createdAt: string;
    updatedAt: string;
    metadata: Record<string, unknown>;
}
export interface AgentTask {
    id: string;
    sessionId: string | null;
    conversationId: string | null;
    requestedByType: 'human' | 'agent' | 'system';
    requestedById: string | null;
    assignedAgentId: string | null;
    title: string;
    taskType: string;
    priority: number;
    status: 'queued' | 'assigned' | 'running' | 'blocked' | 'completed' | 'failed' | 'cancelled';
    input: Record<string, unknown>;
    result: Record<string, unknown> | null;
    errorText: string | null;
    createdAt: string;
    startedAt: string | null;
    completedAt: string | null;
    metadata: Record<string, unknown>;
}
export interface AgentMessage {
    id: string;
    taskId: string | null;
    fromAgentId: string | null;
    toAgentId: string | null;
    messageType: 'status' | 'progress' | 'result' | 'error' | 'request' | 'response';
    payload: Record<string, unknown>;
    createdAt: string;
    acknowledgedAt: string | null;
}
export interface Skill {
    id: string;
    slashCommand: string;
    title: string;
    description: string;
    category: string;
    handlerType: 'internal_function' | 'agent_task' | 'mcp_tool_proxy' | 'prompt_template';
    handlerRef: string;
    inputSchema: Record<string, unknown> | null;
    outputSchema: Record<string, unknown> | null;
    enabled: boolean;
    createdAt: string;
    updatedAt: string;
    metadata: Record<string, unknown>;
}
export interface SkillRun {
    id: string;
    skillId: string;
    sessionId: string | null;
    conversationId: string | null;
    invokedByType: 'human' | 'agent' | 'system';
    invokedById: string | null;
    input: Record<string, unknown>;
    output: Record<string, unknown> | null;
    status: 'queued' | 'running' | 'completed' | 'failed';
    startedAt: string | null;
    completedAt: string | null;
    errorText: string | null;
    createdAt: string;
}
export interface McpServer {
    id: string;
    name: string;
    transport: 'stdio' | 'http';
    endpoint: string | null;
    command: string | null;
    args: string[];
    env: Record<string, string>;
    registrySource: string | null;
    status: 'configured' | 'running' | 'error' | 'stopped';
    enabled: boolean;
    createdAt: string;
    updatedAt: string;
    metadata: Record<string, unknown>;
}
export interface McpTool {
    id: string;
    serverId: string;
    toolName: string;
    title: string | null;
    description: string | null;
    inputSchema: Record<string, unknown> | null;
    discoveredAt: string;
    metadata: Record<string, unknown>;
}
export interface SystemEvent {
    id: string;
    topic: string;
    eventType: string;
    entityType: string;
    entityId: string;
    payload: any;
    createdAt: string;
}
export interface PaginatedResponse<T> {
    items: T[];
    total: number;
    limit: number;
    offset: number;
}
export interface MemoryEntry {
    id: string;
    sessionId: string | null;
    content: string;
    tags: string[];
    visibility: 'private' | 'session' | 'shared' | 'global';
    createdAt: string;
    updatedAt: string;
    metadata: Record<string, unknown>;
}
export interface MemorySearchParams {
    query: string;
    sessionId?: string;
    conversationId?: string;
    role?: string;
    visibility?: 'private' | 'session' | 'shared' | 'global';
    limit?: number;
    offset?: number;
}
export interface MemorySearchResult {
    turns: Turn[];
    total: number;
}
