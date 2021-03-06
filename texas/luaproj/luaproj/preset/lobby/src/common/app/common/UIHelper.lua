﻿local UIHelper = {}

UIHelper.INVALID_CHAIR = -1
UIHelper.chairCount = 0
UIHelper.meChairId = 0

-- 查找子节点
function UIHelper.seekNodeByName(par, name)
	if name == "" then
		return par;
	end

	local node = par:getChildByName(name)
	if node then 
		return node 
	end
	
	if par:getChildrenCount() > 0 then
		local children = par:getChildren()
		for _, child in pairs(children) do
            if child then 
            	local ret = UIHelper.seekNodeByName(child, name)
			    if ret then
				    return ret
			    end
            end
		end
	end
    
end

-- 加载牌到缓存
-- card value 0-12,0是牌里面的A，依次增加
-- 黑红花块
-- 使用的时候，用#image/card_%d.png
function UIHelper.cacheCards()
    local texture = cc.Director:getInstance():getTextureCache():addImage("image/cards.png");
    for i = 0, 3 do
        for j = 0, 12 do
            local frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(j * 90, i * 118, 90, 118))
            cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("image/card_%d.png", i * 13 + j))
            -- printInfo("cache card:%s", string.format("image/card_%d.png", (i - 1) * 13 + (j - 1)))
        end
    end
    -- 小王-52、大王-53、牌背1-54、牌背2-55
    local sp_card = {52, 53, 54, 55}
    for i = 1, #sp_card do
        local frame = cc.SpriteFrame:createWithTexture(texture, cc.rect(i * 90, 590 - 118, 90, 118))
        cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("image/card_%d.png", sp_card[i]))
    end

    -- 小牌
    local texture_small = cc.Director:getInstance():getTextureCache():addImage("image/cards_small.png");
    for i = 0, 3 do
        for j = 0, 12 do
            local frame = cc.SpriteFrame:createWithTexture(texture_small, cc.rect(j * 36, i * 47, 36, 47))
            cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("image/card_small_%d.png", i * 13 + j ))
            -- printInfo("cache card small:%s", string.format("image/card_%d.png", (i - 1) * 13 + (j - 1)))
        end
    end

    for i = 1, #sp_card do
        local frame = cc.SpriteFrame:createWithTexture(texture_small, cc.rect((i - 1) * 36, 239 - 47, 36, 47))
        cc.SpriteFrameCache:getInstance():addSpriteFrame(frame, string.format("image/card_small_%d.png", sp_card[i]))
    end
end

function UIHelper.newCard(cstr, isSmall, anchor)
	local cards_str = string.split(cstr, ",")
	local cards = {}
	for i = 1, #cards_str do
		local img = nil;
		if cards_str[i] ~= "" then 
			if isSmall then
				img = string.format("#image/card_small_%s.png", cards_str[i])
			else
				img = string.format("#image/card_%s.png", cards_str[i])
			end
			local img = display.newSprite(img);
			table.insert(cards, img);

			if anchor then
				img:setAnchorPoint(anchor)
			end
		end
	end
	return cards;
end


function UIHelper.cacheHeads()
    
end

function UIHelper.cacheEffectHome()
    cc.SpriteFrameCache:getInstance():addSpriteFrames("effect/StartEffect.plist")
	cc.SpriteFrameCache:getInstance():addSpriteFrames("effect/shop_sp.plist")
	cc.SpriteFrameCache:getInstance():addSpriteFrames("effect/rank1.plist")
	cc.SpriteFrameCache:getInstance():addSpriteFrames("effect/rank2.plist")
	cc.SpriteFrameCache:getInstance():addSpriteFrames("effect/room_selsp.plist")
	cc.SpriteFrameCache:getInstance():addSpriteFrames("effect/privateroom_sp.plist")
end

--10000 转 1.0万
function UIHelper.formatScoreText(score)
    local scorestr = score or 0

    if scorestr < 10000 then
    elseif score < 100000000 then
        scorestr = string.format("%.2f万", score / 10000)
    else
        scorestr = string.format("%.2f亿", score / 100000000)
    end

    return scorestr
end
function UIHelper.newAnimation(nframes, container, formator, pos, norepeat)
	local spriteFrameCache = cc.SpriteFrameCache:getInstance()
	local frames = {}
	for i = 1, nframes do
		local pa = formator(i);
		table.insert(frames, spriteFrameCache:getSpriteFrame(pa));
	end
	local animation, sprite = display.newAnimation(frames, 0.1)
	local animate = cc.Animate:create(animation)
	sprite:addTo(container);
	if pos then
		sprite:move(pos);
	end

	if norepeat then
		sprite:runAction(cc.Sequence:create(animate, cc.RemoveSelf:create()));
	else
		sprite:runAction(cc.RepeatForever:create(animate));
	end
	return sprite, animate;
end
return UIHelper