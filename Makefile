.PHONY: proto sync-configs run-server clean

# 一键同步共享配置表至客户端资源目录
sync-configs:
	mkdir -p client/assets/configs
	cp configs/*.json client/assets/configs/
	@echo "✅ 共享配置表已同步至 client/assets/configs/"

# 编译 proto 到 Go 服务端
proto: sync-configs
	@if command -v protoc >/dev/null 2>&1; then \
		mkdir -p server/internal/pb && \
		protoc --go_out=. --go_opt=paths=source_relative proto/*.proto && \
		mv proto/*.pb.go server/internal/pb/ && \
		echo "✅ Protobuf 已编译至 server/internal/pb/"; \
	else \
		echo "⚠️ 未检测到 protoc，跳过编译，仅保留 proto/ 契约源文件"; \
	fi

# 启动 Go 服务端网关
run-server:
	cd server && go run ./cmd/gateway/main.go

