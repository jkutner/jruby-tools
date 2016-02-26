require 'java'

java_import 'java.lang.management.ManagementFactory'

def thread_dump
  thread_mx_bean = ManagementFactory.getThreadMXBean
  all_thread_ids = thread_mx_bean.get_all_thread_ids
  thread_infos = thread_mx_bean.get_thread_info(all_thread_ids, 100)

  dump = ""
  thread_infos.each do |thread_info|
    dump += "\"#{thread_info.get_thread_name}\"\n"
    dump += "  java.lang.Thread.State: #{thread_info.get_thread_state}\n"
    stack_trace_elems = thread_info.get_stack_trace
    stack_trace_elems.each do |ste|
      dump += "    #{ste}\n"
    end
    dump += "\n"
  end

  puts dump + "================================="
end

while true
  sleep 5
  threads = 2.times.map do |i|
    Thread.new do
      sleep 5
    end
  end
  thread_dump
  threads.each(&:join)
end
