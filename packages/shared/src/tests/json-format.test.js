import { describe, it, expect } from 'vitest';
// Test fixtures for JSON serialization/deserialization
const testConfig = {
    webPort: 3000,
    apiPort: 4000,
    mcpAdminPort: 5000,
    dataDir: '/data',
    databasePath: '/data/nexus.db',
    realtimeTransport: 'sse',
    agentRuntime: 'child_process',
    bindHost: '0.0.0.0',
};
const testSession = {
    id: 'session-001',
    title: 'Test Session',
    description: 'A test session for JSON validation',
    status: 'active',
    createdAt: '2026-04-02T00:00:00.000Z',
    updatedAt: '2026-04-02T00:00:00.000Z',
    archivedAt: null,
    metadata: { key: 'value' },
};
const testConversation = {
    id: 'conv-001',
    sessionId: 'session-001',
    title: 'Test Conversation',
    source: 'api',
    model: 'claude-4',
    startedAt: '2026-04-02T00:00:00.000Z',
    lastTurnAt: '2026-04-02T00:00:00.000Z',
    status: 'open',
    parentConversationId: null,
    sharedMemoryScope: 'session',
    metadata: {},
};
const testTurn = {
    id: 'turn-001',
    conversationId: 'conv-001',
    sessionId: 'session-001',
    turnIndex: 1,
    role: 'user',
    actorType: 'human',
    actorId: 'user-001',
    contentText: 'Hello, Claude!',
    contentJson: { intent: 'greeting' },
    tokenCountInput: 10,
    tokenCountOutput: 20,
    eventTime: '2026-04-02T00:00:00.000Z',
    parentTurnId: null,
    visibility: 'default',
    metadata: {},
};
const testTurnAttachment = {
    id: 'attach-001',
    turnId: 'turn-001',
    kind: 'code',
    mimeType: 'text/plain',
    title: 'Code snippet',
    contentText: 'const x = 1;',
    contentJson: null,
    filePath: null,
    createdAt: '2026-04-02T00:00:00.000Z',
};
const testMemoryLink = {
    id: 'link-001',
    fromTurnId: 'turn-001',
    toTurnId: 'turn-002',
    linkType: 'related',
    weight: 0.8,
    createdAt: '2026-04-02T00:00:00.000Z',
    metadata: {},
};
const testAgent = {
    id: 'agent-001',
    name: 'TestAgent',
    type: 'general',
    status: 'idle',
    runtimeMode: 'child_process',
    capabilities: ['code-generation', 'analysis'],
    currentTaskId: null,
    createdAt: '2026-04-02T00:00:00.000Z',
    updatedAt: '2026-04-02T00:00:00.000Z',
    metadata: {},
};
const testAgentTask = {
    id: 'task-001',
    sessionId: 'session-001',
    conversationId: 'conv-001',
    requestedByType: 'human',
    requestedById: 'user-001',
    assignedAgentId: 'agent-001',
    title: 'Test Task',
    taskType: 'analysis',
    priority: 1,
    status: 'queued',
    input: { query: 'analyze this' },
    result: null,
    errorText: null,
    createdAt: '2026-04-02T00:00:00.000Z',
    startedAt: null,
    completedAt: null,
    metadata: {},
};
const testAgentMessage = {
    id: 'msg-001',
    taskId: 'task-001',
    fromAgentId: 'agent-001',
    toAgentId: 'agent-002',
    messageType: 'status',
    payload: { progress: 50 },
    createdAt: '2026-04-02T00:00:00.000Z',
    acknowledgedAt: null,
};
const testSkill = {
    id: 'skill-001',
    slashCommand: '/test',
    title: 'Test Skill',
    description: 'A test skill for validation',
    category: 'testing',
    handlerType: 'internal_function',
    handlerRef: 'test-handler',
    inputSchema: { type: 'object' },
    outputSchema: { type: 'object' },
    enabled: true,
    createdAt: '2026-04-02T00:00:00.000Z',
    updatedAt: '2026-04-02T00:00:00.000Z',
    metadata: {},
};
const testSkillRun = {
    id: 'skillrun-001',
    skillId: 'skill-001',
    sessionId: 'session-001',
    conversationId: 'conv-001',
    invokedByType: 'human',
    invokedById: 'user-001',
    input: { test: true },
    output: { result: 'success' },
    status: 'completed',
    startedAt: '2026-04-02T00:00:00.000Z',
    completedAt: '2026-04-02T00:01:00.000Z',
    errorText: null,
    createdAt: '2026-04-02T00:00:00.000Z',
};
const testMcpServer = {
    id: 'mcp-001',
    name: 'Test MCP Server',
    transport: 'stdio',
    endpoint: null,
    command: 'npx',
    args: ['-y', 'test-server'],
    env: {},
    registrySource: null,
    status: 'configured',
    enabled: true,
    createdAt: '2026-04-02T00:00:00.000Z',
    updatedAt: '2026-04-02T00:00:00.000Z',
    metadata: {},
};
const testMcpTool = {
    id: 'mcp-tool-001',
    serverId: 'mcp-001',
    toolName: 'test_tool',
    title: 'Test Tool',
    description: 'A test MCP tool',
    inputSchema: { type: 'object', properties: {} },
    discoveredAt: '2026-04-02T00:00:00.000Z',
    metadata: {},
};
const testSystemEvent = {
    id: 'event-001',
    topic: 'agent.status',
    eventType: 'status_change',
    entityType: 'agent',
    entityId: 'agent-001',
    payload: { status: 'busy' },
    createdAt: '2026-04-02T00:00:00.000Z',
};
const testPaginatedResponse = {
    items: [testTurn],
    total: 1,
    limit: 10,
    offset: 0,
};
const testMemoryEntry = {
    id: 'mem-001',
    sessionId: 'session-001',
    content: 'Test memory content',
    tags: ['test', 'validation'],
    visibility: 'session',
    createdAt: '2026-04-02T00:00:00.000Z',
    updatedAt: '2026-04-02T00:00:00.000Z',
    metadata: {},
};
const testMemorySearchParams = {
    query: 'test query',
    sessionId: 'session-001',
    conversationId: 'conv-001',
    role: 'user',
    visibility: 'session',
    limit: 10,
    offset: 0,
};
const testMemorySearchResult = {
    turns: [testTurn],
    total: 1,
};
describe('JSON Format Validation Tests', () => {
    describe('Config', () => {
        it('should serialize Config to JSON', () => {
            const json = JSON.stringify(testConfig);
            expect(json).toBeTruthy();
            expect(() => JSON.parse(json)).not.toThrow();
        });
        it('should deserialize JSON to Config', () => {
            const json = JSON.stringify(testConfig);
            const parsed = JSON.parse(json);
            expect(parsed).toEqual(testConfig);
        });
        it('should have required fields', () => {
            const json = JSON.stringify(testConfig);
            const parsed = JSON.parse(json);
            expect(parsed).toHaveProperty('webPort');
            expect(parsed).toHaveProperty('apiPort');
            expect(parsed).toHaveProperty('mcpAdminPort');
            expect(parsed).toHaveProperty('dataDir');
            expect(parsed).toHaveProperty('databasePath');
            expect(parsed).toHaveProperty('realtimeTransport');
            expect(parsed).toHaveProperty('agentRuntime');
            expect(parsed).toHaveProperty('bindHost');
        });
    });
    describe('Session', () => {
        it('should serialize Session to JSON', () => {
            const json = JSON.stringify(testSession);
            expect(json).toBeTruthy();
        });
        it('should deserialize JSON to Session', () => {
            const json = JSON.stringify(testSession);
            const parsed = JSON.parse(json);
            expect(parsed).toEqual(testSession);
        });
        it('should handle nullable fields', () => {
            expect(testSession.archivedAt).toBeNull();
            const json = JSON.stringify(testSession);
            const parsed = JSON.parse(json);
            expect(parsed.archivedAt).toBeNull();
        });
    });
    describe('Conversation', () => {
        it('should serialize Conversation to JSON', () => {
            const json = JSON.stringify(testConversation);
            expect(json).toBeTruthy();
        });
        it('should deserialize JSON to Conversation', () => {
            const json = JSON.stringify(testConversation);
            const parsed = JSON.parse(json);
            expect(parsed).toEqual(testConversation);
        });
        it('should have valid status enum', () => {
            expect(testConversation.status).toMatch(/^(open|closed)$/);
        });
    });
    describe('Turn', () => {
        it('should serialize Turn to JSON', () => {
            const json = JSON.stringify(testTurn);
            expect(json).toBeTruthy();
        });
        it('should deserialize JSON to Turn', () => {
            const json = JSON.stringify(testTurn);
            const parsed = JSON.parse(json);
            expect(parsed).toEqual(testTurn);
        });
        it('should handle nested contentJson', () => {
            expect(testTurn.contentJson).toEqual({ intent: 'greeting' });
            const json = JSON.stringify(testTurn);
            const parsed = JSON.parse(json);
            expect(parsed.contentJson).toEqual({ intent: 'greeting' });
        });
        it('should have valid role and actorType enums', () => {
            expect(testTurn.role).toMatch(/^(user|assistant|system|tool)$/);
            expect(testTurn.actorType).toMatch(/^(human|agent|system|tool)$/);
        });
    });
    describe('TurnAttachment', () => {
        it('should serialize TurnAttachment to JSON', () => {
            const json = JSON.stringify(testTurnAttachment);
            expect(json).toBeTruthy();
        });
        it('should deserialize JSON to TurnAttachment', () => {
            const json = JSON.stringify(testTurnAttachment);
            const parsed = JSON.parse(json);
            expect(parsed).toEqual(testTurnAttachment);
        });
        it('should have valid kind enum', () => {
            expect(testTurnAttachment.kind).toMatch(/^(code|file|image|tool_output|other)$/);
        });
    });
    describe('MemoryLink', () => {
        it('should serialize MemoryLink to JSON', () => {
            const json = JSON.stringify(testMemoryLink);
            expect(json).toBeTruthy();
        });
        it('should deserialize JSON to MemoryLink', () => {
            const json = JSON.stringify(testMemoryLink);
            const parsed = JSON.parse(json);
            expect(parsed).toEqual(testMemoryLink);
        });
        it('should have valid linkType enum', () => {
            expect(testMemoryLink.linkType).toMatch(/^(references|related|derived|responds_to)$/);
        });
    });
    describe('Agent', () => {
        it('should serialize Agent to JSON', () => {
            const json = JSON.stringify(testAgent);
            expect(json).toBeTruthy();
        });
        it('should deserialize JSON to Agent', () => {
            const json = JSON.stringify(testAgent);
            const parsed = JSON.parse(json);
            expect(parsed).toEqual(testAgent);
        });
        it('should handle capabilities array', () => {
            expect(testAgent.capabilities).toEqual(['code-generation', 'analysis']);
            const json = JSON.stringify(testAgent);
            const parsed = JSON.parse(json);
            expect(parsed.capabilities).toEqual(['code-generation', 'analysis']);
        });
        it('should have valid type and status enums', () => {
            expect(testAgent.type).toMatch(/^(frontend-dev|backend-dev|research|tester|general)$/);
            expect(testAgent.status).toMatch(/^(idle|busy|offline)$/);
        });
    });
    describe('AgentTask', () => {
        it('should serialize AgentTask to JSON', () => {
            const json = JSON.stringify(testAgentTask);
            expect(json).toBeTruthy();
        });
        it('should deserialize JSON to AgentTask', () => {
            const json = JSON.stringify(testAgentTask);
            const parsed = JSON.parse(json);
            expect(parsed).toEqual(testAgentTask);
        });
        it('should have valid status enum', () => {
            expect(testAgentTask.status).toMatch(/^(queued|assigned|running|blocked|completed|failed|cancelled)$/);
        });
    });
    describe('AgentMessage', () => {
        it('should serialize AgentMessage to JSON', () => {
            const json = JSON.stringify(testAgentMessage);
            expect(json).toBeTruthy();
        });
        it('should deserialize JSON to AgentMessage', () => {
            const json = JSON.stringify(testAgentMessage);
            const parsed = JSON.parse(json);
            expect(parsed).toEqual(testAgentMessage);
        });
        it('should handle payload object', () => {
            expect(testAgentMessage.payload).toEqual({ progress: 50 });
            const json = JSON.stringify(testAgentMessage);
            const parsed = JSON.parse(json);
            expect(parsed.payload).toEqual({ progress: 50 });
        });
    });
    describe('Skill', () => {
        it('should serialize Skill to JSON', () => {
            const json = JSON.stringify(testSkill);
            expect(json).toBeTruthy();
        });
        it('should deserialize JSON to Skill', () => {
            const json = JSON.stringify(testSkill);
            const parsed = JSON.parse(json);
            expect(parsed).toEqual(testSkill);
        });
        it('should have valid handlerType enum', () => {
            expect(testSkill.handlerType).toMatch(/^(internal_function|agent_task|mcp_tool_proxy|prompt_template)$/);
        });
    });
    describe('SkillRun', () => {
        it('should serialize SkillRun to JSON', () => {
            const json = JSON.stringify(testSkillRun);
            expect(json).toBeTruthy();
        });
        it('should deserialize JSON to SkillRun', () => {
            const json = JSON.stringify(testSkillRun);
            const parsed = JSON.parse(json);
            expect(parsed).toEqual(testSkillRun);
        });
        it('should have valid status enum', () => {
            expect(testSkillRun.status).toMatch(/^(queued|running|completed|failed)$/);
        });
    });
    describe('McpServer', () => {
        it('should serialize McpServer to JSON', () => {
            const json = JSON.stringify(testMcpServer);
            expect(json).toBeTruthy();
        });
        it('should deserialize JSON to McpServer', () => {
            const json = JSON.stringify(testMcpServer);
            const parsed = JSON.parse(json);
            expect(parsed).toEqual(testMcpServer);
        });
        it('should handle args array', () => {
            expect(testMcpServer.args).toEqual(['-y', 'test-server']);
            const json = JSON.stringify(testMcpServer);
            const parsed = JSON.parse(json);
            expect(parsed.args).toEqual(['-y', 'test-server']);
        });
        it('should have valid transport enum', () => {
            expect(testMcpServer.transport).toMatch(/^(stdio|http)$/);
        });
    });
    describe('McpTool', () => {
        it('should serialize McpTool to JSON', () => {
            const json = JSON.stringify(testMcpTool);
            expect(json).toBeTruthy();
        });
        it('should deserialize JSON to McpTool', () => {
            const json = JSON.stringify(testMcpTool);
            const parsed = JSON.parse(json);
            expect(parsed).toEqual(testMcpTool);
        });
    });
    describe('SystemEvent', () => {
        it('should serialize SystemEvent to JSON', () => {
            const json = JSON.stringify(testSystemEvent);
            expect(json).toBeTruthy();
        });
        it('should deserialize JSON to SystemEvent', () => {
            const json = JSON.stringify(testSystemEvent);
            const parsed = JSON.parse(json);
            expect(parsed).toEqual(testSystemEvent);
        });
    });
    describe('PaginatedResponse', () => {
        it('should serialize PaginatedResponse to JSON', () => {
            const json = JSON.stringify(testPaginatedResponse);
            expect(json).toBeTruthy();
        });
        it('should deserialize JSON to PaginatedResponse', () => {
            const json = JSON.stringify(testPaginatedResponse);
            const parsed = JSON.parse(json);
            expect(parsed).toEqual(testPaginatedResponse);
        });
        it('should handle nested items array', () => {
            expect(testPaginatedResponse.items).toHaveLength(1);
            const json = JSON.stringify(testPaginatedResponse);
            const parsed = JSON.parse(json);
            expect(parsed.items).toHaveLength(1);
        });
    });
    describe('MemoryEntry', () => {
        it('should serialize MemoryEntry to JSON', () => {
            const json = JSON.stringify(testMemoryEntry);
            expect(json).toBeTruthy();
        });
        it('should deserialize JSON to MemoryEntry', () => {
            const json = JSON.stringify(testMemoryEntry);
            const parsed = JSON.parse(json);
            expect(parsed).toEqual(testMemoryEntry);
        });
        it('should handle tags array', () => {
            expect(testMemoryEntry.tags).toEqual(['test', 'validation']);
            const json = JSON.stringify(testMemoryEntry);
            const parsed = JSON.parse(json);
            expect(parsed.tags).toEqual(['test', 'validation']);
        });
    });
    describe('MemorySearchParams', () => {
        it('should serialize MemorySearchParams to JSON', () => {
            const json = JSON.stringify(testMemorySearchParams);
            expect(json).toBeTruthy();
        });
        it('should deserialize JSON to MemorySearchParams', () => {
            const json = JSON.stringify(testMemorySearchParams);
            const parsed = JSON.parse(json);
            expect(parsed).toEqual(testMemorySearchParams);
        });
    });
    describe('MemorySearchResult', () => {
        it('should serialize MemorySearchResult to JSON', () => {
            const json = JSON.stringify(testMemorySearchResult);
            expect(json).toBeTruthy();
        });
        it('should deserialize JSON to MemorySearchResult', () => {
            const json = JSON.stringify(testMemorySearchResult);
            const parsed = JSON.parse(json);
            expect(parsed).toEqual(testMemorySearchResult);
        });
    });
    describe('JSON round-trip validation', () => {
        it('should preserve all data through serialize/deserialize cycle', () => {
            const entities = [
                testConfig,
                testSession,
                testConversation,
                testTurn,
                testTurnAttachment,
                testMemoryLink,
                testAgent,
                testAgentTask,
                testAgentMessage,
                testSkill,
                testSkillRun,
                testMcpServer,
                testMcpTool,
                testSystemEvent,
                testPaginatedResponse,
                testMemoryEntry,
                testMemorySearchParams,
                testMemorySearchResult,
            ];
            for (const entity of entities) {
                const json = JSON.stringify(entity);
                const parsed = JSON.parse(json);
                expect(parsed).toEqual(entity);
            }
        });
        it('should maintain JSON validity for all types', () => {
            const entities = [
                testConfig,
                testSession,
                testConversation,
                testTurn,
                testTurnAttachment,
                testMemoryLink,
                testAgent,
                testAgentTask,
                testAgentMessage,
                testSkill,
                testSkillRun,
                testMcpServer,
                testMcpTool,
                testSystemEvent,
                testPaginatedResponse,
                testMemoryEntry,
                testMemorySearchParams,
                testMemorySearchResult,
            ];
            for (const entity of entities) {
                const json = JSON.stringify(entity);
                expect(() => JSON.parse(json)).not.toThrow();
                expect(typeof JSON.parse(json)).toBe('object');
            }
        });
    });
    describe('ISO 8601 datetime validation', () => {
        it('should use ISO 8601 format for all datetime fields', () => {
            const dateFields = [
                'createdAt',
                'updatedAt',
                'archivedAt',
                'startedAt',
                'lastTurnAt',
                'eventTime',
                'completedAt',
                'acknowledgedAt',
                'discoveredAt',
            ];
            const iso8601Regex = /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}.\d{3}Z$/;
            for (const entity of [testSession, testConversation, testTurn, testAgent, testAgentTask]) {
                for (const field of dateFields) {
                    const value = entity[field];
                    if (value !== null && value !== undefined) {
                        expect(value).toMatch(iso8601Regex);
                    }
                }
            }
        });
    });
    describe('metadata field validation', () => {
        it('should accept empty metadata objects', () => {
            const entity = { ...testSession, metadata: {} };
            const json = JSON.stringify(entity);
            const parsed = JSON.parse(json);
            expect(parsed.metadata).toEqual({});
        });
        it('should accept nested metadata objects', () => {
            const entity = {
                ...testSession,
                metadata: { nested: { deep: { value: 123 } } },
            };
            const json = JSON.stringify(entity);
            const parsed = JSON.parse(json);
            expect(parsed.metadata).toEqual({ nested: { deep: { value: 123 } } });
        });
        it('should accept array metadata', () => {
            const entity = { ...testSession, metadata: { items: [1, 2, 3] } };
            const json = JSON.stringify(entity);
            const parsed = JSON.parse(json);
            expect(parsed.metadata).toEqual({ items: [1, 2, 3] });
        });
    });
});
