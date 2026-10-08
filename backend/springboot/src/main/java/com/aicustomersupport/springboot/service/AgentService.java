package com.aicustomersupport.springboot.service;

import org.springframework.stereotype.Service;
// import com.aicustomersupport.springboot.entity.Order;
// import com.aicustomersupport.springboot.entity.Refund;

@Service 
public class AgentService {
    // private final OrderService orderService;
    // private final RefundService refundService;
    private final ToolRegistry toolRegistry;

    // public AgentService(OrderService orderService, RefundService refundService) {
    //     this.orderService = orderService;
    //     this.refundService = refundService;
    // }

    public AgentService(ToolRegistry toolRegistry){
        this.toolRegistry = toolRegistry;
    }

    public AgentResult handleTicket(String subCategory, Long orderId) {
    AgentTool tool = toolRegistry.getTool(subCategory);
    if (tool == null) {
        return new AgentResult(
                false,
                true,
                "No agent tool available for this request."
        );
    }
    return tool.execute(orderId);
}

    // public AgentResult handleTicket(String subCategory, Long orderId){

    //     System.out.println("AGENT SUBCATEGORY = [" + subCategory + "]");
    //     System.out.println("AGENT ORDER ID = [" + orderId + "]");
    //     if("track_order".equalsIgnoreCase(subCategory)){
    //         if(orderId == null){
    //             return new AgentResult(
    //                 false,
    //                 true,
    //                 "Order ID is required to track the order."
    //             );
    //         }
    //         Order order = orderService.getOrderByOrderId(String.valueOf(orderId));
    //         if(order == null){
    //             return new AgentResult(
    //                 false,
    //                 true,
    //                 "Order not found."
    //             );
    //         }
    //         return new AgentResult(
    //             true,
    //             false,
    //             "Order " + order.getOrderId() + " is currently " + order.getStatus() + "."
    //         );
    //     }
        
    //     if ("cancel_order".equalsIgnoreCase(subCategory)) {
    //         if (orderId == null) {
    //             return new AgentResult(
    //                 false,
    //                 true,
    //                 "Order ID is required to cancel the order."
    //             );
    //         }
    //         String result = orderService.cancelOrder(String.valueOf(orderId));
    //         return new AgentResult(
    //             true,
    //             false,
    //             result
    //         );
    //     }

    //     if("check_refund".equalsIgnoreCase(subCategory) || "track_refund".equalsIgnoreCase(subCategory)){
    //         if(orderId == null){
    //             return new AgentResult(
    //                 false,
    //                 true,
    //                 "Order ID is required to check refund status."
    //             );
    //         }
    //         Refund refund = refundService.getRefundByOrderId(String.valueOf(orderId));
    //         if(refund == null){
    //             return new AgentResult(
    //                 false,
    //                 true,
    //                 "No refund found for order " + orderId + "."
    //             );
    //         }
    //         return new AgentResult(
    //             true,
    //             false,
    //             "Refund for order " + orderId
    //                 + " is currently " + refund.getStatus()
    //                 + " for amount " + refund.getAmount() + "."
    //         );
    //     }
    //     return new AgentResult(
    //         false,
    //         true,
    //         "This request requires human review."
    //     );
    // }

}
