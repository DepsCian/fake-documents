local Message = {}

function Message.success(text)
	sampAddChatMessage("{00AAFF}[Fake Documents]: {FFFFFF}" .. text, -1)
end

function Message.info(text)
	sampAddChatMessage("{00AAFF}[Fake Documents]: {CCCCCC}" .. text, -1)
end

return Message
