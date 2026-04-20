/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#include <spdlog/spdlog.h>
#include <spdlog/sinks/basic_file_sink.h>
#include <spdlog/sinks/stdout_color_sinks.h>
#include "lib/di/container.hpp"

void Logger::setLevel(const std::string &name) const {
	debug("Setting log level to: {}.", name);
	const auto level = spdlog::level::from_str(name);
	spdlog::set_level(level);
}

std::string Logger::getLevel() const {
	const auto level = spdlog::level::to_string_view(spdlog::get_level());
	return std::string { level.begin(), level.end() };
}

void Logger::logProfile(const std::string &name, double duration_ms) const {
	std::string mutable_name = name;

	std::ranges::replace(mutable_name, ':', '_');
	std::ranges::replace(mutable_name, '\\', '_');
	std::ranges::replace(mutable_name, '/', '_');

	std::string filename = "log/profile_log-" + mutable_name + ".txt";

	const auto it = profile_loggers_.find(filename);
	if (it == profile_loggers_.end()) {
		try {
			auto file_sink = std::make_shared<spdlog::sinks::basic_file_sink_mt>(filename, true);
			const auto profile_logger = std::make_shared<spdlog::logger>(mutable_name, file_sink);
			profile_loggers_[filename] = profile_logger;
			profile_logger->info("Function {} executed in {} ms", name, duration_ms);
		} catch (const spdlog::spdlog_ex &ex) {
			error("Profile log initialization failed: {}", ex.what());
		}
	} else {
		it->second->info("Function {} executed in {} ms", mutable_name, duration_ms);
	}
}

void Logger::logMarket(const std::string &msg) const {
	const auto tm = get_local_time();
	std::string filename = fmt::format("data/logs/market_transactions-{:02d}-{:02d}.log", tm.tm_mday, tm.tm_mon + 1);

	const auto it = market_loggers_.find(filename);
	if (it == market_loggers_.end()) {
		try {
			auto file_sink = std::make_shared<spdlog::sinks::basic_file_sink_mt>(filename, false);
			file_sink->set_pattern("[%Y-%m-%d %H:%M:%S] %v");
			const auto market_logger = std::make_shared<spdlog::logger>("market_" + filename, file_sink);
			market_loggers_[filename] = market_logger;
			market_logger->info(msg);
			market_logger->flush();
		} catch (const spdlog::spdlog_ex &ex) {
			error("Market log initialization failed: {}", ex.what());
		}
	} else {
		it->second->info(msg);
		it->second->flush();
	}
}

void Logger::logParcel(const std::string &msg) const {
	const auto tm = get_local_time();
	std::string filename = fmt::format("data/logs/parcel_transactions-{:02d}-{:02d}.log", tm.tm_mday, tm.tm_mon + 1);

	const auto it = parcel_loggers_.find(filename);
	if (it == parcel_loggers_.end()) {
		try {
			auto file_sink = std::make_shared<spdlog::sinks::basic_file_sink_mt>(filename, false);
			file_sink->set_pattern("[%Y-%m-%d %H:%M:%S] %v");
			const auto parcel_logger = std::make_shared<spdlog::logger>("parcel_" + filename, file_sink);
			parcel_loggers_[filename] = parcel_logger;
			parcel_logger->info(msg);
			parcel_logger->flush();
		} catch (const spdlog::spdlog_ex &ex) {
			error("Parcel log initialization failed: {}", ex.what());
		}
	} else {
		it->second->info(msg);
		it->second->flush();
	}
}

void Logger::info(const std::string &msg) const {
	SPDLOG_INFO("{}", msg);
}

void Logger::warn(const std::string &msg) const {
	SPDLOG_WARN("{}", msg);
}

void Logger::error(const std::string &msg) const {
	SPDLOG_ERROR("{}", msg);
}

void Logger::critical(const std::string &msg) const {
	SPDLOG_CRITICAL("{}", msg);
}

#if defined(DEBUG_LOG)
void Logger::debug(const std::string &msg) const {
	SPDLOG_DEBUG("{}", msg);
}

void Logger::trace(const std::string &msg) const {
	SPDLOG_TRACE("{}", msg);
}
#endif
